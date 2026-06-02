# Get one page of rows from a dataset

Fetches a single page of rows from a dataset. Use
[`dc_collect()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_collect.md)
to fetch all pages automatically, or iterate manually with
`page = 1L, 2L, ...`.

## Usage

``` r
dc_get(
  client,
  dataset_id,
  start = NULL,
  end = NULL,
  symbols = NULL,
  page = 1L,
  limit = 100L,
  ...
)
```

## Arguments

- client:

  A `datacore_client` created with
  [`datacore_client()`](https://datacore-vietnam.github.io/datacore-r/reference/datacore_client.md).

- dataset_id:

  Character. The dataset id, e.g. `"equity.vn30.daily"`.

- start:

  Optional. Start date (inclusive). A `Date`, `POSIXt`, or
  `"yyyy-mm-dd"` string.

- end:

  Optional. End date (inclusive). A `Date`, `POSIXt`, or `"yyyy-mm-dd"`
  string.

- symbols:

  Optional. Character vector of ticker symbols to filter by. Will be
  comma-joined for the `symbols=` query parameter.

- page:

  Integer. Page number (1-based). Defaults to `1L`.

- limit:

  Integer. Rows per page. Defaults to `100L` (server maximum).

- ...:

  Additional named arguments passed through as query parameters.

## Value

A tibble. Columns depend on the dataset; see
[`dc_schema()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_schema.md).

## See also

[`dc_collect()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_collect.md)
to auto-paginate,
[`dc_download()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_download.md)
to save to disk.

## Examples

``` r
if (FALSE) { # \dontrun{
  dc <- datacore_client()

  # First page of VN30 daily
  pg1 <- dc_get(dc, "equity.vn30.daily",
                start = "2024-01-01", page = 1L, limit = 100L)

  # For all pages at once, use dc_collect()
  all <- dc_collect(dc, "equity.vn30.daily", start = "2024-01-01")
} # }
```
