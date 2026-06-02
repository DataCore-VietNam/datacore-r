#' Search the DataCore catalog
#'
#' Free-text search across dataset names, descriptions, and tags. Returns the
#' top `limit` matches as a tibble.
#'
#' @param client A `datacore_client` created with [datacore_client()].
#' @param query Character. The search query, e.g. `"VN30 fundamentals"`.
#' @param limit Integer. Maximum number of results to return. Defaults to 20.
#'
#' @return A tibble of dataset stubs. Typical columns include `id`, `name`,
#'   `domain`, `product`, `description`.
#'
#' @examples
#' \dontrun{
#'   dc <- datacore_client()
#'   dc_search(dc, "VN30 fundamentals")
#'   dc_search(dc, "macro inflation", limit = 5)
#' }
#'
#' @export
dc_search <- function(client, query, limit = 20L) {
  check_client(client)
  if (!is.character(query) || length(query) != 1L || !nzchar(query)) {
    rlang::abort("`query` must be a non-empty character string.")
  }
  if (!is.numeric(limit) || length(limit) != 1L || limit <= 0) {
    rlang::abort("`limit` must be a positive integer.")
  }
  body <- list(query = query, limit = as.integer(limit))
  resp <- dc_request(client, "POST", "/search", body = body)
  records_to_tibble(resp)
}
