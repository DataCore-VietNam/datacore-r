#' List top-level data domains
#'
#' Returns the top-level domains in the DataCore catalog (e.g. equity, macro,
#' fx, fixed-income).
#'
#' @param client A `datacore_client` created with [datacore_client()].
#'
#' @return A tibble with one row per domain. Typical columns: `id`, `name`,
#'   `description`.
#'
#' @examples
#' \dontrun{
#'   dc <- datacore_client()
#'   dc_list_domains(dc)
#' }
#'
#' @export
dc_list_domains <- function(client) {
  check_client(client)
  resp <- dc_request(client, "GET", "/domains")
  records_to_tibble(resp)
}

#' List products within a domain
#'
#' Returns the products (sub-categories) for a given domain, for example,
#' within the `equity` domain you might find `vn30`, `hose`, `hnx`.
#'
#' @param client A `datacore_client` created with [datacore_client()].
#' @param domain Character. The domain id, e.g. `"equity"`.
#'
#' @return A tibble of products. Typical columns: `id`, `name`, `domain`,
#'   `description`.
#'
#' @examples
#' \dontrun{
#'   dc <- datacore_client()
#'   dc_list_products(dc, "equity")
#' }
#'
#' @export
dc_list_products <- function(client, domain) {
  check_client(client)
  if (!is.character(domain) || length(domain) != 1L || !nzchar(domain)) {
    rlang::abort("`domain` must be a non-empty character string.")
  }
  path <- sprintf("/domains/%s/products", utils::URLencode(domain, reserved = TRUE))
  resp <- dc_request(client, "GET", path)
  records_to_tibble(resp)
}

#' List datasets, optionally filtered by product
#'
#' Lists datasets in the catalog. If `product` is supplied, only datasets
#' belonging to that product are returned.
#'
#' @param client A `datacore_client` created with [datacore_client()].
#' @param product Character or `NULL`. Product id to filter by, e.g.
#'   `"vn30"`. Default `NULL` lists all datasets.
#'
#' @return A tibble of dataset stubs. Typical columns: `id`, `name`, `product`,
#'   `frequency`, `coverage_start`, `coverage_end`.
#'
#' @examples
#' \dontrun{
#'   dc <- datacore_client()
#'   dc_list_datasets(dc)
#'   dc_list_datasets(dc, product = "vn30")
#' }
#'
#' @export
dc_list_datasets <- function(client, product = NULL) {
  check_client(client)
  query <- if (!is.null(product)) list(product = product) else NULL
  resp <- dc_request(client, "GET", "/datasets", query = query)
  records_to_tibble(resp)
}
