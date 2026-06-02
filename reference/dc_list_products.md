# List products within a domain

Returns the products (sub-categories) for a given domain.

## Usage

``` r
dc_list_products(client, domain)
```

## Arguments

- client:

  A `datacore_client` created with
  [`datacore_client()`](https://datacore-vietnam.github.io/datacore-r/reference/datacore_client.md).

- domain:

  Character. The domain id, e.g. `"equity"`.

## Value

A tibble of products.

## Examples

``` r
if (FALSE) { # \dontrun{
  dc <- datacore_client()
  dc_list_products(dc, "equity")
} # }
```
