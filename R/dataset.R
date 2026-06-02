#' Get dataset metadata
#'
#' Returns the full metadata document for a dataset: license, frequency,
#' coverage, publisher, columns summary, last updated time, etc.
#'
#' @param client A `datacore_client` created with [datacore_client()].
#' @param dataset_id Character. The dataset id, e.g. `"equity.vn30.daily"`.
#'
#' @return A list with the dataset metadata.
#'
#' @examples
#' \dontrun{
#'   dc <- datacore_client()
#'   meta <- dc_metadata(dc, "equity.vn30.daily")
#'   meta$frequency
#' }
#'
#' @export
dc_metadata <- function(client, dataset_id) {
  check_client(client)
  validate_dataset_id(dataset_id)
  path <- sprintf("/datasets/%s", utils::URLencode(dataset_id, reserved = TRUE))
  dc_request(client, "GET", path)
}

#' Get a dataset's schema
#'
#' Returns the column-level schema (name, type, description, unit, nullable).
#'
#' @param client A `datacore_client` created with [datacore_client()].
#' @param dataset_id Character. The dataset id.
#'
#' @return A tibble with one row per column.
#'
#' @examples
#' \dontrun{
#'   dc <- datacore_client()
#'   dc_schema(dc, "equity.vn30.daily")
#' }
#'
#' @export
dc_schema <- function(client, dataset_id) {
  check_client(client)
  validate_dataset_id(dataset_id)
  path <- sprintf("/datasets/%s/schema", utils::URLencode(dataset_id, reserved = TRUE))
  resp <- dc_request(client, "GET", path)
  records_to_tibble(resp)
}

#' Preview a dataset without an API key
#'
#' Returns a small sample of rows from a public dataset preview endpoint,
#' without requiring authentication. Useful for exploring the catalog before
#' subscribing.
#'
#' @param dataset_id Character. The dataset id, e.g. `"equity.vn30.daily"`.
#' @param n Integer. Number of preview rows to return. Defaults to 10.
#' @param base_url Character. Base URL for the API.
#'
#' @return A tibble with up to `n` rows.
#'
#' @examples
#' \dontrun{
#'   # No API key required
#'   dc_preview("equity.vn30.daily")
#'   dc_preview("macro.cpi.monthly", n = 5)
#' }
#'
#' @export
dc_preview <- function(dataset_id, n = 10L,
                       base_url = "https://api.datacore.vn/v1") {
  validate_dataset_id(dataset_id)
  if (!is.numeric(n) || length(n) != 1L || n <= 0) {
    rlang::abort("`n` must be a positive integer.")
  }
  base_url <- sub("/$", "", base_url)
  path <- sprintf("/datasets/%s/preview", utils::URLencode(dataset_id, reserved = TRUE))
  url <- paste0(base_url, path)
  req <- httr2::request(url) |>
    httr2::req_url_query(n = as.integer(n)) |>
    httr2::req_headers(
      Accept = "application/json",
      `User-Agent` = paste0("datacore-r/", utils::packageVersion("datacore"))
    ) |>
    httr2::req_timeout(30) |>
    httr2::req_error(is_error = function(resp) FALSE)
  resp <- httr2::req_perform(req)
  handle_response(resp, path)  |> records_to_tibble()
}

#' Get a sample of rows from a dataset
#'
#' @param client A `datacore_client` created with [datacore_client()].
#' @param dataset_id Character. The dataset id.
#' @param n Integer. Number of rows to return. Defaults to 10.
#'
#' @return A tibble with up to `n` rows.
#'
#' @examples
#' \dontrun{
#'   dc <- datacore_client()
#'   dc_sample(dc, "equity.vn30.daily", n = 5)
#' }
#'
#' @export
dc_sample <- function(client, dataset_id, n = 10L) {
  check_client(client)
  validate_dataset_id(dataset_id)
  if (!is.numeric(n) || length(n) != 1L || n <= 0) {
    rlang::abort("`n` must be a positive integer.")
  }
  path <- sprintf("/datasets/%s/sample", utils::URLencode(dataset_id, reserved = TRUE))
  resp <- dc_request(client, "GET", path, query = list(n = as.integer(n)))
  records_to_tibble(resp)
}

#' Get one page of rows from a dataset
#'
#' Fetches a single page of rows. Use [dc_collect()] to fetch all pages
#' automatically, or iterate manually with `page = 1L, 2L, ...`.
#'
#' @param client A `datacore_client` created with [datacore_client()].
#' @param dataset_id Character. The dataset id, e.g. `"equity.vn30.daily"`.
#' @param start Optional. Start date (inclusive). A `Date`, `POSIXt`, or
#'   `"yyyy-mm-dd"` string.
#' @param end Optional. End date (inclusive).
#' @param symbols Optional. Character vector of ticker symbols to filter by.
#' @param page Integer. Page number (1-based). Defaults to `1L`.
#' @param limit Integer. Rows per page. Defaults to `100L` (server maximum).
#' @param ... Additional named arguments passed as query parameters.
#'
#' @return A tibble. Columns depend on the dataset; see [dc_schema()].
#'
#' @examples
#' \dontrun{
#'   dc <- datacore_client()
#'
#'   # First page of VN30 daily
#'   pg1 <- dc_get(dc, "equity.vn30.daily", start = "2024-01-01", page = 1L)
#'
#'   # Second page
#'   pg2 <- dc_get(dc, "equity.vn30.daily", start = "2024-01-01", page = 2L)
#'
#'   # For all pages at once, use dc_collect()
#' }
#'
#' @seealso [dc_collect()] to auto-paginate, [dc_download()] to save to disk.
#'
#' @export
dc_get <- function(client, dataset_id,
                   start = NULL, end = NULL, symbols = NULL,
                   page = 1L, limit = 100L, ...) {
  check_client(client)
  validate_dataset_id(dataset_id)
  if (!is.numeric(page) || length(page) != 1L || page < 1L) {
    rlang::abort("`page` must be a positive integer.")
  }
  if (!is.numeric(limit) || length(limit) != 1L || limit < 1L) {
    rlang::abort("`limit` must be a positive integer.")
  }
  extra <- list(...)
  query <- c(
    list(
      start   = format_date(start, "start"),
      end     = format_date(end, "end"),
      symbols = format_symbols(symbols),
      page    = as.integer(page),
      limit   = as.integer(limit)
    ),
    extra
  )
  path <- sprintf("/datasets/%s/data", utils::URLencode(dataset_id, reserved = TRUE))
  resp <- dc_request(client, "GET", path, query = query)
  records_to_tibble(resp)
}

#' Fetch all rows from a dataset, paginating automatically
#'
#' Repeatedly calls the API until all pages are retrieved (or `max_rows` is
#' reached) and returns a single combined tibble.
#'
#' @param client A `datacore_client` created with [datacore_client()].
#' @param dataset_id Character. The dataset id.
#' @param start Optional. Start date (inclusive).
#' @param end Optional. End date (inclusive).
#' @param symbols Optional. Character vector of ticker symbols.
#' @param limit Integer. Rows per page. Defaults to `100L`.
#' @param max_rows Integer or `NULL`. Stop after this many rows. `NULL` (the
#'   default) fetches everything.
#' @param verbose Logical. Print a progress line per page. Defaults to
#'   `interactive()`.
#' @param ... Additional named arguments passed as query parameters.
#'
#' @return A single tibble combining all pages.
#'
#' @examples
#' \dontrun{
#'   dc <- datacore_client()
#'
#'   # Fetch all VN30 daily data for 2024
#'   vn30 <- dc_collect(dc, "equity.vn30.daily",
#'                      start = "2024-01-01", end = "2024-12-31")
#'
#'   # Cap at 500 rows for exploration
#'   sample <- dc_collect(dc, "equity.vn30.daily",
#'                        start = "2023-01-01", max_rows = 500L) }
#'
#' @seealso [dc_get()] for a single page, [dc_download()] to save to disk.
#'
#' @export
dc_collect <- function(client, dataset_id,
                       start = NULL, end = NULL, symbols = NULL,
                       limit = 100L, max_rows = NULL,
                       verbose = interactive(), ...) {
  check_client(client)
  validate_dataset_id(dataset_id)
  pages <- list()
  page  <- 1L
  rows_so_far <- 0L

  repeat {
    if (verbose) message(sprintf("  Fetching page %d ...", page))
    chunk <- dc_get(client, dataset_id,
                    start = start, end = end, symbols = symbols,
                    page = page, limit = as.integer(limit), ...)
    n_chunk <- nrow(chunk)
    if (n_chunk == 0L) break
    rows_so_far <- rows_so_far + n_chunk
    if (!is.null(max_rows) && rows_so_far >= max_rows) {
      keep <- max_rows - (rows_so_far - n_chunk)
      pages[[page]] <- chunk[seq_len(keep), , drop = FALSE]
      break
    }
    pages[[page]] <- chunk
    if (n_chunk < limit) break
    page <- page + 1L
  }
  if (length(pages) == 0L) return(tibble::tibble())
  do.call(rbind, pages)
}

#' Download all rows of a dataset to a CSV file
#'
#' @param client A `datacore_client` created with [datacore_client()].
#' @param dataset_id Character. The dataset id.
#' @param output_path Character. File path for the CSV output.
#' @param start Optional. Start date (inclusive).
#' @param end Optional. End date (inclusive).
#' @param symbols Optional. Character vector of ticker symbols.
#' @param limit Integer. Rows per page. Defaults to `100L`.
#' @param verbose Logical. Print progress. Defaults to `interactive()`.
#' @param ... Additional named arguments passed as query parameters.
#'
#' @return Invisibly returns a list with `output_path`, `pages_downloaded`,
#'   and `rows_downloaded`.
#'
#' @examples
#' \dontrun{
#'   dc <- datacore_client()
#'   dc_download(dc, "equity.vn30.daily",
#'               output_path = "vn30_2024.csv",
#'               start = "2024-01-01", end = "2024-12-31")
#' }
#'
#' @seealso [dc_collect()] to load all rows into memory.
#'
#' @export
dc_download <- function(client, dataset_id, output_path,
                        start = NULL, end = NULL, symbols = NULL,
                        limit = 100L, verbose = interactive(), ...) {
  check_client(client)
  validate_dataset_id(dataset_id)
  if (!is.character(output_path) || length(output_path) != 1L || !nzchar(output_path)) {
    rlang::abort("`output_path` must be a non-empty character string.")
  }
  page <- 1L
  total_rows <- 0L
  wrote_header <- FALSE
  repeat {
    if (verbose) message(sprintf("  Downloading page %d ...", page))
    chunk <- dc_get(client, dataset_id,
                    start = start, end = end, symbols = symbols,
                    page = page, limit = as.integer(limit), ...)
    n_chunk <- nrow(chunk)
    if (n_chunk == 0L) break
    utils::write.csv(chunk, file = output_path, row.names = FALSE,
                     append = wrote_header, fileEncoding = "UTF-8")
    wrote_header <- TRUE
    total_rows <- total_rows + n_chunk
    if (n_chunk < limit) break
    page <- page + 1L
  }
  if (verbose) message(sprintf("  Done: %d rows written to %s", total_rows, output_path))
  invisible(list(output_path = output_path,
                 pages_downloaded = page - 1L + (total_rows > 0L),
                 rows_downloaded = total_rows))
}

validate_dataset_id <- function(dataset_id) {
  if (!is.character(dataset_id) || length(dataset_id) != 1L || !nzchar(dataset_id) ||
      is.na(dataset_id)) {
    rlang::abort("`dataset_id` must be a non-empty character string.")
  }
  invisible(dataset_id)
}
