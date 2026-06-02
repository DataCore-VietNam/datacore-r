# Preview a dataset without an API key

Returns a small sample of rows from a public dataset preview endpoint,
without requiring authentication. Useful for exploring the catalog
before subscribing.

## Usage

``` r
dc_preview(dataset_id, n = 10L, base_url = "https://api.datacore.vn/v1")
```

## Arguments

- dataset_id:

  Character. The dataset id, e.g. `"equity.vn30.daily"`.

- n:

  Integer. Number of preview rows to return. Defaults to 10.

- base_url:

  Character. Base URL for the API. Defaults to the public endpoint
  `https://api.datacore.vn/v1`.

## Value

A tibble with up to `n` rows.

## Examples

``` r
if (FALSE) { # \dontrun{
  # No API key required
  dc_preview("equity.vn30.daily")
  dc_preview("macro.cpi.monthly", n = 5)
} # }
```
