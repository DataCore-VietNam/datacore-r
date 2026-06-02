# datacore

Official R client for [DataCore](https://datacore.vn) – Vietnamese
financial, alternative, and economic data. Tibble-native,
tidyverse-compatible, with built-in pagination, retry, and rate-limit
handling.

## Installation

``` r

# CRAN (once available)
install.packages("datacore")

# Latest development version from GitHub
# install.packages("pak")
pak::pak("DataCore-VietNam/datacore-r")
```

## Authentication

Get a free API key at [datacore.vn/keys](https://datacore.vn/keys).
Store it in your environment so it is never hardcoded:

``` r

# Recommended: add to ~/.Renviron (restart R after editing)
usethis::edit_r_environ()
# Add the line: DATACORE_API_KEY=dc_live_...

# Or set for the current session only
Sys.setenv(DATACORE_API_KEY = "dc_live_...")
```

## Quick start

``` r

library(datacore)

dc <- datacore_client()   # reads DATACORE_API_KEY from environment

# Browse what is available
dc_list_domains(dc)
dc_search(dc, "VN30 daily")

# Pull VN30 daily prices for 2024
vn30 <- dc_collect(dc, "equity.vn30.daily",
                   start = "2024-01-01",
                   end   = "2024-12-31")

head(vn30)
```

## Preview without an API key

``` r

dc_preview("equity.vn30.daily", n = 5)
```

## Core functions

### Fetching data

``` r

dc <- datacore_client()

# One page (manual pagination)
pg1 <- dc_get(dc, "equity.vn30.daily", start = "2024-01-01", page = 1L)

# All pages combined into one tibble
vn30 <- dc_collect(dc, "equity.vn30.daily",
                   start = "2024-01-01", end = "2024-12-31")

# Stream all pages directly to CSV (constant memory usage)
dc_download(dc, "equity.vn30.daily",
            output_path = "vn30_2024.csv",
            start = "2024-01-01", end = "2024-12-31")
```

### Catalog browsing

``` r

dc_list_domains(dc)                          # top-level domains
dc_list_products(dc, "equity")               # products in a domain
dc_list_datasets(dc, product = "vn30")       # datasets in a product
dc_search(dc, "inflation monthly", limit = 5L)

dc_metadata(dc, "equity.vn30.daily")         # full metadata
dc_schema(dc, "equity.vn30.daily")           # column-level schema as tibble
dc_sample(dc, "equity.vn30.daily", n = 5)   # random sample rows
```

## Tidyverse compatibility

``` r

library(dplyr)

vn30 <- dc_collect(dc, "equity.vn30.daily", start = "2023-01-01")

vn30 |>
  filter(symbol %in% c("VNM", "VIC", "VHM")) |>
  group_by(symbol) |>
  summarise(
    obs       = n(),
    last_date = max(date),
    avg_close = mean(close)
  )
```

## Function reference

| Function | Description | Key required |
|----|----|----|
| [`datacore_client()`](https://DataCore-VietNam.github.io/datacore-r/reference/datacore_client.md) | Create a client | Yes |
| `dc_preview(dataset_id, n)` | Preview rows, no auth | No |
| `dc_get(client, dataset_id, ...)` | One page of rows | Yes |
| `dc_collect(client, dataset_id, ...)` | All pages, one tibble | Yes |
| `dc_download(client, dataset_id, output_path, ...)` | Write all pages to CSV | Yes |
| `dc_search(client, query, limit)` | Free-text catalog search | Yes |
| `dc_list_domains(client)` | List data domains | Yes |
| `dc_list_products(client, domain)` | List products in a domain | Yes |
| `dc_list_datasets(client, product)` | List datasets | Yes |
| `dc_metadata(client, dataset_id)` | Full dataset metadata | Yes |
| `dc_schema(client, dataset_id)` | Column schema as tibble | Yes |
| `dc_sample(client, dataset_id, n)` | Random sample rows | Yes |

Full documentation at <https://DataCore-VietNam.github.io/datacore-r/>.

## Error handling

All API errors surface as classed conditions you can catch with
[`tryCatch()`](https://rdrr.io/r/base/conditions.html):

| Class                       | When                             |
|-----------------------------|----------------------------------|
| `datacore_auth_error`       | Missing or invalid API key (401) |
| `datacore_not_found_error`  | Dataset does not exist (404)     |
| `datacore_rate_limit_error` | Too many requests (429)          |
| `datacore_server_error`     | Server error (5xx)               |
| `datacore_api_error`        | Other API errors                 |

All inherit from `datacore_api_error` for catch-all handling:

``` r

tryCatch(
  dc_collect(dc, "equity.vn30.daily"),
  datacore_auth_error      = function(e) message("Check your API key"),
  datacore_rate_limit_error = function(e) message("Slow down"),
  datacore_api_error       = function(e) message("API error: ", conditionMessage(e))
)
```

## Contributing

See
[CONTRIBUTING.md](https://DataCore-VietNam.github.io/datacore-r/CONTRIBUTING.md).
All contributions are welcome.

## License

MIT – see
[LICENSE.md](https://DataCore-VietNam.github.io/datacore-r/LICENSE.md).
