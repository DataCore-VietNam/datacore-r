# Changelog

## datacore (development version)

## datacore 0.1.0

### Initial release

- [`datacore_client()`](https://datacore-vietnam.github.io/datacore-r/reference/datacore_client.md):
  construct an authenticated API client with key masking and validation
- [`dc_get()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_get.md):
  fetch a single page of rows from any dataset
- [`dc_collect()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_collect.md):
  auto-paginate and return all rows as a single tibble
- [`dc_download()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_download.md):
  stream all pages to a CSV file with constant memory usage
- [`dc_preview()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_preview.md):
  preview dataset rows without an API key
- [`dc_search()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_search.md):
  free-text search across the catalog
- [`dc_list_domains()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_list_domains.md),
  [`dc_list_products()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_list_products.md),
  [`dc_list_datasets()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_list_datasets.md):
  browse the catalog hierarchy
- [`dc_metadata()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_metadata.md),
  [`dc_schema()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_schema.md),
  [`dc_sample()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_sample.md):
  inspect individual datasets
- Tibble-native output, tidyverse-compatible
- Retry on 5xx and 429 responses with `Retry-After` support
- Classed error hierarchy (`datacore_auth_error`,
  `datacore_not_found_error`, `datacore_rate_limit_error`,
  `datacore_server_error`, `datacore_api_error`)
