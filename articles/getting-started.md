# Getting started with datacore

`datacore` is the official R client for [DataCore](https://datacore.vn),
the Vietnamese financial and alternative data platform. Every endpoint
returns a tibble, dates are real `Date` objects, and the client handles
rate limits and retries transparently.

## 1. Installation

``` r

# install.packages("pak")
pak::pak("DataCore-VietNam/datacore-r")
```

## 2. Set your API key

Create a free account at <https://datacore.vn> to get an API key. The
recommended place to store it is `~/.Renviron`:

    DATACORE_API_KEY=dc_live_xxxxxxxxxxxxxxxx

Restart your R session and you are ready. You can also pass the key
directly:

``` r

library(datacore)
dc <- datacore_client(api_key = "dc_live_xxxxxxxxxxxxxxxx")
```

For all examples below we assume the environment variable is set:

``` r

library(datacore)
dc <- datacore_client()
dc
#> <datacore_client>
#>   base_url: https://api.datacore.vn/v1
#>   timeout:  30s
#>   api_key:  dc_l************xxxx
```

## 3. Search the catalog

``` r

hits <- dc_search(dc, "VN30 fundamentals", limit = 5)
hits
#> # A tibble: 5 x 4
#>   id                    name                 domain product
#>   <chr>                 <chr>                <chr>  <chr>
#> 1 equity.vn30.daily     VN30 Daily Prices    equity vn30
#> 2 equity.vn30.fund      VN30 Fundamentals    equity vn30
```

## 4. Browse domains and products

``` r

dc_list_domains(dc)
#> # A tibble: 4 x 3
#>   id          name                 description
#>   <chr>       <chr>                <chr>
#> 1 equity      Equities             Vietnamese listed equities
#> 2 macro       Macro & Economy      GSO, GDP, CPI, IIP
#> 3 fx          Foreign Exchange     SBV reference rates
#> 4 fixed-income Fixed Income        Government & corporate bonds

dc_list_products(dc, "equity")
```

## 5. Pull VN30 daily data

``` r

library(dplyr)

vn30 <- dc_get(
  dc,
  "equity.vn30.daily",
  start = "2024-01-01",
  end   = "2024-12-31"
)

vn30 |>
  group_by(symbol) |>
  summarise(
    obs       = n(),
    last_date = max(date),
    last_px   = last(close)
  )
```

Filter to specific tickers:

``` r

focus <- dc_get(
  dc,
  "equity.vn30.daily",
  start   = "2024-01-01",
  symbols = c("VNM", "VIC", "VHM")
)
```

## Where to next

- `dc_schema(dc, "equity.vn30.daily")` for column-level documentation
- `dc_sample(dc, "equity.vn30.daily")` for a quick preview without date
  filters
- Full API reference at
  <https://datacore-vietnam.github.io/datacore-r/reference/>
