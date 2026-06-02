# Download all rows of a dataset to a CSV file

Paginates through the dataset and writes each page to `output_path` as
it arrives, so memory usage stays constant regardless of dataset size.

## Usage

``` r
dc_download(
  client,
  dataset_id,
  output_path,
  start = NULL,
  end = NULL,
  symbols = NULL,
  limit = 100L,
  verbose = interactive(),
  ...
)
```

## Arguments

- client:

  A `datacore_client` created with
  [`datacore_client()`](https://datacore-vietnam.github.io/datacore-r/reference/datacore_client.md).

- dataset_id:

  Character. The dataset id, e.g. `"equity.vn30.daily"`.

- output_path:

  Character. File path for the CSV output.

- start:

  Optional. Start date (inclusive). A `Date`, `POSIXt`, or
  `"yyyy-mm-dd"` string.

- end:

  Optional. End date (inclusive).

- symbols:

  Optional. Character vector of ticker symbols to filter by.

- limit:

  Integer. Rows per page. Defaults to `100L`.

- verbose:

  Logical. Print progress. Defaults to
  [`interactive()`](https://rdrr.io/r/base/interactive.html).

- ...:

  Additional named arguments passed as query parameters.

## Value

Invisibly returns a list with `output_path`, `pages_downloaded`, and
`rows_downloaded`.

## See also

[`dc_collect()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_collect.md)
to load all rows into memory.

## Examples

``` r
if (FALSE) { # \dontrun{
  dc <- datacore_client()
  dc_download(dc, "equity.vn30.daily",
              output_path = "vn30_2024.csv",
              start = "2024-01-01", end = "2024-12-31")
} # }
```
