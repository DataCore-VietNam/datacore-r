# Package index

## Client

Create and inspect a DataCore client

- [`datacore_client()`](https://datacore-vietnam.github.io/datacore-r/reference/datacore_client.md)
  : Create a DataCore API client
- [`datacore`](https://datacore-vietnam.github.io/datacore-r/reference/datacore-package.md)
  [`datacore-package`](https://datacore-vietnam.github.io/datacore-r/reference/datacore-package.md)
  : datacore: Official R Client for DataCore Vietnamese Financial Data

## Fetch data

Pull rows from a dataset

- [`dc_get()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_get.md)
  : Get one page of rows from a dataset
- [`dc_collect()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_collect.md)
  : Fetch all rows from a dataset, paginating automatically
- [`dc_download()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_download.md)
  : Download all rows of a dataset to a CSV file
- [`dc_preview()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_preview.md)
  : Preview a dataset without an API key

## Catalog

Browse and search available datasets

- [`dc_search()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_search.md)
  : Search the DataCore catalog
- [`dc_list_domains()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_list_domains.md)
  : List top-level data domains
- [`dc_list_products()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_list_products.md)
  : List products within a domain
- [`dc_list_datasets()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_list_datasets.md)
  : List datasets, optionally filtered by product

## Dataset details

Inspect metadata, schema, and samples

- [`dc_metadata()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_metadata.md)
  : Get dataset metadata
- [`dc_schema()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_schema.md)
  : Get a dataset's schema
- [`dc_sample()`](https://datacore-vietnam.github.io/datacore-r/reference/dc_sample.md)
  : Get a sample of rows from a dataset
