#' datacore: Official R Client for DataCore Vietnamese Financial Data
#'
#' Tibble-native R client for the DataCore catalog of Vietnamese financial,
#' alternative, and economic data.
#'
#' @section Getting started:
#' Set the `DATACORE_API_KEY` environment variable (or pass `api_key` to
#' [datacore_client()]) and construct a client:
#'
#' \preformatted{
#' dc <- datacore_client()
#' dc_search(dc, "VN30")
#' vn30 <- dc_get(dc, "equity.vn30.daily", start = "2024-01-01")
#' }
#'
#' @keywords internal
"_PACKAGE"
