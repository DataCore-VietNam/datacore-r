# Get a dataset's schema

Returns the column-level schema (name, type, description, unit,
nullable).

## Usage

``` r
dc_schema(client, dataset_id)
```

## Arguments

- client:

  A `datacore_client` created with
  [`datacore_client()`](https://datacore-vietnam.github.io/datacore-r/reference/datacore_client.md).

- dataset_id:

  Character. The dataset id, e.g. `"equity.vn30.daily"`.

## Value

A tibble with one row per column.

## Examples

``` r
if (FALSE) { # \dontrun{
  dc <- datacore_client()
  dc_schema(dc, "equity.vn30.daily")
} # }
```
