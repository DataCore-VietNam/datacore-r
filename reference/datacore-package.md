# datacore: Official R Client for DataCore Vietnamese Financial Data

Tibble-native R client for the DataCore catalog of Vietnamese financial,
alternative, and economic data.

## Getting started

Set the `DATACORE_API_KEY` environment variable (or pass `api_key` to
[`datacore_client()`](https://DataCore-VietNam.github.io/datacore-r/reference/datacore_client.md))
and construct a client:


    dc <- datacore_client()
    dc_search(dc, "VN30")
    vn30 <- dc_get(dc, "equity.vn30.daily", start = "2024-01-01")
