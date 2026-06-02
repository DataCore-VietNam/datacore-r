# Search the DataCore catalog

Free-text search across dataset names, descriptions, and tags. Returns
the top `limit` matches as a tibble.

## Usage

``` r
dc_search(client, query, limit = 20L)
```

## Arguments

- client:

  A `datacore_client` created with
  [`datacore_client()`](https://datacore-vietnam.github.io/datacore-r/reference/datacore_client.md).

- query:

  Character. The search query, e.g. `"VN30 fundamentals"`.

- limit:

  Integer. Maximum number of results to return. Defaults to 20.

## Value

A tibble of dataset stubs. Typical columns include `id`, `name`,
`domain`, `product`, `description`.

## Examples

``` r
if (FALSE) { # \dontrun{
  dc <- datacore_client()
  dc_search(dc, "VN30 fundamentals")
  dc_search(dc, "macro inflation", limit = 5)
} # }
```
