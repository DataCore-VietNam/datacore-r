# Get dataset metadata

Returns the full metadata document for a dataset.

## Usage

``` r
dc_metadata(client, dataset_id)
```

## Arguments

- client:

  A `datacore_client` created with
  [`datacore_client()`](https://datacore-vietnam.github.io/datacore-r/reference/datacore_client.md).

- dataset_id:

  Character. The dataset id, e.g. `"equity.vn30.daily"`.

## Value

A list with the dataset metadata.

## Examples

``` r
if (FALSE) { # \dontrun{
  dc <- datacore_client()
  meta <- dc_metadata(dc, "equity.vn30.daily")
} # }
```
