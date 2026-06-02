#' Create a DataCore API client
#'
#' Construct a client object that holds the API key, base URL, and request
#' timeout. The client is passed as the first argument to every other function
#' in the package.
#'
#' @param api_key Character. Your DataCore API key. If `NULL` (the default),
#'   the environment variable `DATACORE_API_KEY` is consulted. An error is
#'   raised if neither is set.
#' @param base_url Character. Base URL for the API. Defaults to the public
#'   endpoint `https://api.datacore.vn/v1`.
#' @param timeout Numeric. Per-request timeout in seconds. Defaults to 30.
#'
#' @return An object of class `"datacore_client"`: a list with elements
#'   `api_key`, `base_url`, and `timeout`.
#'
#' @examples
#' \dontrun{
#'   # Read key from DATACORE_API_KEY env var
#'   dc <- datacore_client()
#'
#'   # Or pass explicitly
#'   dc <- datacore_client(api_key = "dc_live_...")
#' }
#'
#' @export
datacore_client <- function(api_key = NULL,
                            base_url = "https://api.datacore.vn/v1",
                            timeout = 30) {
  if (is.null(api_key)) {
    api_key <- Sys.getenv("DATACORE_API_KEY", unset = "")
  }
  if (!nzchar(api_key)) {
    rlang::abort(
      c(
        "No DataCore API key provided.",
        i = "Set the DATACORE_API_KEY environment variable, or pass api_key to datacore_client().",
        i = "Get a key at https://datacore.vn"
      ),
      class = "datacore_auth_error"
    )
  }
  if (!is.character(base_url) || length(base_url) != 1L) {
    rlang::abort("`base_url` must be a single character string.")
  }
  if (!is.numeric(timeout) || length(timeout) != 1L || timeout <= 0) {
    rlang::abort("`timeout` must be a positive number.")
  }

  structure(
    list(
      api_key = api_key,
      base_url = sub("/$", "", base_url),
      timeout = timeout
    ),
    class = "datacore_client"
  )
}

#' @export
print.datacore_client <- function(x, ...) {
  cat("<datacore_client>\n")
  cat("  base_url: ", x$base_url, "\n", sep = "")
  cat("  timeout:  ", x$timeout, "s\n", sep = "")
  cat("  api_key:  ", mask_key(x$api_key), "\n", sep = "")
  invisible(x)
}

mask_key <- function(key) {
  if (!nzchar(key)) return("<unset>")
  n <- nchar(key)
  if (n <= 8L) return(strrep("*", n))
  paste0(substr(key, 1L, 4L), strrep("*", n - 8L), substr(key, n - 3L, n))
}

is_datacore_client <- function(x) inherits(x, "datacore_client")

check_client <- function(client) {
  if (!is_datacore_client(client)) {
    rlang::abort("`client` must be a `datacore_client` created with datacore_client().")
  }
  invisible(client)
}

# Build a request --------------------------------------------------------------

dc_build_request <- function(client, method, path, query = NULL, body = NULL) {
  url <- paste0(client$base_url, "/", sub("^/", "", path))
  req <- httr2::request(url) |>
    httr2::req_method(method) |>
    httr2::req_headers(
      Authorization = paste("Bearer", client$api_key),
      Accept = "application/json",
      `User-Agent` = paste0("datacore-r/", utils::packageVersion("datacore"))
    ) |>
    httr2::req_timeout(client$timeout) |>
    httr2::req_retry(
      max_tries = 3,
      is_transient = function(resp) {
        status <- httr2::resp_status(resp)
        status == 429 || (status >= 500 && status < 600)
      },
      after = function(resp) {
        ra <- httr2::resp_header(resp, "Retry-After")
        if (is.null(ra)) 1 else suppressWarnings(as.numeric(ra))
      }
    ) |>
    httr2::req_error(is_error = function(resp) FALSE)

  if (!is.null(query)) {
    query <- drop_nulls(query)
    if (length(query) > 0L) {
      req <- httr2::req_url_query(req, !!!query)
    }
  }
  if (!is.null(body)) {
    req <- httr2::req_body_json(req, body)
  }
  req
}

#' @keywords internal
#' @noRd
dc_request <- function(client, method, path, query = NULL, body = NULL) {
  check_client(client)
  req <- dc_build_request(client, method, path, query = query, body = body)
  resp <- httr2::req_perform(req)
  handle_response(resp, path)
}

handle_response <- function(resp, path) {
  status <- httr2::resp_status(resp)
  if (status >= 200 && status < 300) {
    if (httr2::resp_has_body(resp)) {
      return(httr2::resp_body_json(resp, simplifyVector = FALSE))
    }
    return(invisible(NULL))
  }

  body_text <- tryCatch(httr2::resp_body_string(resp), error = function(e) "")
  detail <- extract_error_message(body_text)

  if (status == 401L) {
    rlang::abort(
      c(
        "DataCore API: authentication failed (401).",
        i = "Check that your API key is valid and not expired.",
        x = detail
      ),
      class = "datacore_auth_error"
    )
  }
  if (status == 404L) {
    rlang::abort(
      c(
        sprintf("DataCore API: resource not found (404) at `%s`.", path),
        x = detail
      ),
      class = "datacore_not_found_error"
    )
  }
  if (status == 429L) {
    retry_after <- httr2::resp_header(resp, "Retry-After")
    rlang::abort(
      c(
        "DataCore API: rate limit exceeded (429).",
        i = if (!is.null(retry_after))
          sprintf("Server requested retry after %s seconds.", retry_after)
        else "Please slow down requests and retry.",
        x = detail
      ),
      class = "datacore_rate_limit_error"
    )
  }
  if (status >= 500L) {
    rlang::abort(
      c(
        sprintf("DataCore API: server error (%d).", status),
        i = "This is likely transient; please retry shortly.",
        x = detail
      ),
      class = "datacore_server_error"
    )
  }

  rlang::abort(
    c(
      sprintf("DataCore API: request failed (%d) at `%s`.", status, path),
      x = detail
    ),
    class = "datacore_api_error"
  )
}

extract_error_message <- function(body_text) {
  if (!nzchar(body_text)) return("")
  parsed <- tryCatch(
    jsonlite::fromJSON(body_text, simplifyVector = TRUE),
    error = function(e) NULL
  )
  if (is.null(parsed)) return(substr(body_text, 1L, 200L))
  for (key in c("message", "error", "detail", "msg")) {
    if (!is.null(parsed[[key]]) && nzchar(as.character(parsed[[key]]))) {
      return(as.character(parsed[[key]]))
    }
  }
  substr(body_text, 1L, 200L)
}

drop_nulls <- function(x) x[!vapply(x, is.null, logical(1L))]
