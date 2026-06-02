# List top-level data domains

Returns the top-level domains in the DataCore catalog (e.g. equity,
macro, fx, fixed-income).

## Usage

``` r
dc_list_domains(client)
```

## Arguments

- client:

  A `datacore_client` created with
  [`datacore_client()`](https://datacore-vietnam.github.io/datacore-r/reference/datacore_client.md).

## Value

A tibble with one row per domain.

## Examples

``` r
if (FALSE) { # \dontrun{
  dc <- datacore_client()
  dc_list_domains(dc)
} # }
```
