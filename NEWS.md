# datacore (development version)

# datacore 0.1.0

## Initial release

* `datacore_client()`: construct an authenticated API client with key masking and validation
* `dc_get()`: fetch a single page of rows from any dataset
* `dc_collect()`: auto-paginate and return all rows as a single tibble
* `dc_download()`: stream all pages to a CSV file with constant memory usage
* `dc_preview()`: preview dataset rows without an API key
* `dc_search()`: free-text search across the catalog
* `dc_list_domains()`, `dc_list_products()`, `dc_list_datasets()`: browse the catalog hierarchy
* `dc_metadata()`, `dc_schema()`, `dc_sample()`: inspect individual datasets
* Tibble-native output, tidyverse-compatible
* Retry on 5xx and 429 responses with `Retry-After` support
* Classed error hierarchy (`datacore_auth_error`, `datacore_not_found_error`, `datacore_rate_limit_error`, `datacore_server_error`, `datacore_api_error`)
