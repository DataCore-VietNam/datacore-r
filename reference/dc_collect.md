# Fetch all rows from a dataset, paginating automatically

Repeatedly calls the API until all pages are retrieved (or `max_rows` is
reached) and returns a single combined tibble.

## Usage

``` r
dc_collect(
  client,
  dataset_id,
  start = NULL,
  end = NULL,
  symbols = NULL,
  limit = 100L,
  max_rows = NULL,
  verbose = interactive(),
  ...
)
```

## Arguments

- client:

  A `datacore_client` created with
  [`datacore_client()`](https://DataCore-VietNam.github.io/datacore-r/reference/datacore_client.md).

- dataset_id:

  Character. The dataset id, e.g. `"equity.vn30.daily"`.

- start:

  Optional. Start date (inclusive). A `Date`, `POSIXt`, or
  `"yyyy-mm-dd"` string.

- end:

  Optional. End date (inclusive).

- symbols:

  Optional. Character vector of ticker symbols to filter by.

- limit:

  Integer. Rows per page. Defaults to `100L`.

- max_rows:

  Integer or `NULL`. Stop after this many rows. `NULL` (the default)
  fetches everything.

- verbose:

  Logical. Print a progress line per page. Defaults to
  [`interactive()`](https://rdrr.io/r/base/interactive.html).

- ...:

  Additional named arguments passed as query parameters.

## Value

A single tibble combining all pages.

## See also

[`dc_get()`](https://DataCore-VietNam.github.io/datacore-r/reference/dc_get.md)
for a single page,
[`dc_download()`](https://DataCore-VietNam.github.io/datacore-r/reference/dc_download.md)
to save to disk.

## Examples

``` r
if (FALSE) { # \dontrun{
  dc <- datacore_client()

  # Fetch all VN30 daily data for 2024
  vn30 <- dc_collect(dc, "equity.vn30.daily",
                     start = "2024-01-01", end = "2024-12-31")

  # Cap at 500 rows for exploration
  sample <- dc_collect(dc, "equity.vn30.daily",
                       start = "2023-01-01", max_rows = 500L)
} # }
```
