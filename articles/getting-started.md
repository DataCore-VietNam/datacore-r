# Getting started with datacore

## datacore

`datacore` is the official R client for [DataCore](https://datacore.vn),
the Vietnamese financial and alternative data platform. It is built to
feel like a native tidyverse package: every endpoint returns a tibble,
dates are real `Date` objects, and the client respects rate limits and
retries transparently.

This vignette walks you through:

1.  Installation
2.  Setting an API key
3.  Searching the catalog
4.  Browsing domains and products
5.  Pulling VN30 daily prices

### 1. Installation

``` r

# install.packages("remotes")
remotes::install_github("DataCore-VietNam/datacore-r")
```

### 2. Set your API key

Get a key from <https://datacore.vn> and set it as an environment
variable. The recommended place is `~/.Renviron`:

    DATACORE_API_KEY=dc_live_xxxxxxxxxxxxxxxx

Restart your R session and you’re ready. You can also pass the key
explicitly for one-off scripts:

``` r

library(datacore)
dc <- datacore_client(api_key = "dc_live_xxxxxxxxxxxxxxxx")
```

For everything below we’ll assume the environment variable is set:

``` r

library(datacore)
dc <- datacore_client()
dc
#> <datacore_client>
#>   base_url: https://api.datacore.vn/v1
#>   timeout:  30s
#>   api_key:  dc_l************xxxx
```

### 3. Example: search the catalog

``` r

hits <- dc_search(dc, "VN30 fundamentals", limit = 5)
hits
#> # A tibble: 5 x 4
#>   id                    name                 domain product
#>   <chr>                 <chr>                <chr>  <chr>
#> 1 equity.vn30.daily     VN30 Daily Prices    equity vn30
#> 2 equity.vn30.fund      VN30 Fundamentals    equity vn30
#> ...
```

### 4. Example: browse domains and products

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

### 5. Example: pull VN30 daily

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

Filter to a few tickers:

``` r

focus <- dc_get(
  dc,
  "equity.vn30.daily",
  start   = "2024-01-01",
  symbols = c("VNM", "VIC", "VHM")
)
```

### Where to next

- `dc_schema(dc, "equity.vn30.daily")` for column-level documentation
- `dc_sample(dc, "equity.vn30.daily")` for a quick preview
- The [DataCore
  cookbook](https://github.com/DataCore-VietNam/datacore-cookbook) for
  end-to-end examples (factor models, event studies, Tidy Finance VN)
