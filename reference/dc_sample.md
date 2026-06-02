# Get a sample of rows from a dataset

Useful for previewing what
[`dc_get()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_get.md)
will return without pulling the full time series.

## Usage

``` r
dc_sample(client, dataset_id, n = 10L)
```

## Arguments

- client:

  A `datacore_client` created with
  [`datacore_client()`](https://datacore-vietnam.github.io/datacore-r/reference/datacore_client.md).

- dataset_id:

  Character. The dataset id, e.g. `"equity.vn30.daily"`.

- n:

  Integer. Number of rows to return. Defaults to 10.

## Value

A tibble with up to `n` rows.

## Examples

``` r
if (FALSE) { # \dontrun{
  dc <- datacore_client()
  dc_sample(dc, "equity.vn30.daily", n = 5)
} # }
```
