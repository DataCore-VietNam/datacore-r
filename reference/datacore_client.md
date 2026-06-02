# Create a DataCore API client

Construct a client object that holds the API key, base URL, and request
timeout. The client is passed as the first argument to every other
function in the package.

## Usage

``` r
datacore_client(
  api_key = NULL,
  base_url = "https://api.datacore.vn/v1",
  timeout = 30
)
```

## Arguments

- api_key:

  Character. Your DataCore API key. If `NULL` (the default), the
  environment variable `DATACORE_API_KEY` is consulted. An error is
  raised if neither is set.

- base_url:

  Character. Base URL for the API. Defaults to the public endpoint
  `https://api.datacore.vn/v1`.

- timeout:

  Numeric. Per-request timeout in seconds. Defaults to 30.

## Value

An object of class `"datacore_client"` — a list with elements `api_key`,
`base_url`, and `timeout`.

## Examples

``` r
if (FALSE) { # \dontrun{
  # Read key from DATACORE_API_KEY env var
  dc <- datacore_client()

  # Or pass explicitly
  dc <- datacore_client(api_key = "dc_live_...")
} # }
```
