# List datasets, optionally filtered by product

Lists datasets in the catalog. If `product` is supplied, only datasets
belonging to that product are returned.

## Usage

``` r
dc_list_datasets(client, product = NULL)
```

## Arguments

- client:

  A `datacore_client` created with
  [`datacore_client()`](https://datacore-vietnam.github.io/datacore-r/reference/datacore_client.md).

- product:

  Character or `NULL`. Product id to filter by.

## Value

A tibble of dataset stubs.

## Examples

``` r
if (FALSE) { # \dontrun{
  dc <- datacore_client()
  dc_list_datasets(dc)
  dc_list_datasets(dc, product = "vn30")
} # }
```
