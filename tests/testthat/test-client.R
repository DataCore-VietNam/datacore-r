test_that("datacore_client errors when no key is available", {
  withr::with_envvar(
    new = c(DATACORE_API_KEY = ""),
    expect_error(datacore_client(), class = "datacore_auth_error")
  )
})

test_that("datacore_client picks up DATACORE_API_KEY from env", {
  withr::with_envvar(
    new = c(DATACORE_API_KEY = "dc_env_key"),
    {
      dc <- datacore_client()
      expect_s3_class(dc, "datacore_client")
      expect_identical(dc$api_key, "dc_env_key")
    }
  )
})

test_that("datacore_client returns proper structure", {
  dc <- datacore_client(api_key = "dc_test")
  expect_s3_class(dc, "datacore_client")
  expect_named(dc, c("api_key", "base_url", "timeout"))
  expect_identical(dc$api_key, "dc_test")
  expect_identical(dc$base_url, "https://api.datacore.vn/v1")
  expect_identical(dc$timeout, 30)
})

test_that("datacore_client validates base_url and timeout", {
  expect_error(datacore_client(api_key = "dc_test", base_url = 123))
  expect_error(datacore_client(api_key = "dc_test", timeout = -1))
  expect_error(datacore_client(api_key = "dc_test", timeout = "fast"))
})

test_that("trailing slash on base_url is stripped", {
  dc <- datacore_client(api_key = "dc_test", base_url = "https://example.com/v1/")
  expect_identical(dc$base_url, "https://example.com/v1")
})

test_that("print.datacore_client masks the key", {
  dc <- datacore_client(api_key = "dc_supersecretkey")
  out <- utils::capture.output(print(dc))
  expect_true(any(grepl("datacore_client", out)))
  expect_false(any(grepl("supersecret", out)))
})

test_that("dc_search returns a tibble (mocked response)", {
  dc <- datacore_client(api_key = "dc_test")
  fake_body <- list(
    list(id = "equity.vn30.daily", name = "VN30 Daily", domain = "equity"),
    list(id = "equity.vn30.fund",  name = "VN30 Fundamentals", domain = "equity")
  )
  fake_resp <- httr2::response_json(status_code = 200L, body = fake_body)

  result <- httr2::with_mocked_responses(
    list(fake_resp),
    dc_search(dc, "VN30")
  )
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 2L)
  expect_true(all(c("id", "name", "domain") %in% names(result)))
})

test_that("401 surfaces an auth error", {
  dc <- datacore_client(api_key = "dc_test")
  fake_resp <- httr2::response_json(
    status_code = 401L,
    body = list(message = "invalid api key")
  )
  expect_error(
    httr2::with_mocked_responses(
      list(fake_resp),
      dc_search(dc, "VN30")
    ),
    class = "datacore_auth_error"
  )
})

test_that("404 surfaces a not-found error", {
  dc <- datacore_client(api_key = "dc_test")
  fake_resp <- httr2::response_json(
    status_code = 404L,
    body = list(message = "no such dataset")
  )
  expect_error(
    httr2::with_mocked_responses(
      list(fake_resp),
      dc_metadata(dc, "equity.nope")
    ),
    class = "datacore_not_found_error"
  )
})

test_that("429 surfaces a rate-limit error mentioning retry", {
  dc <- datacore_client(api_key = "dc_test")
  fake_resp <- httr2::response_json(
    status_code = 429L,
    headers = list(`Retry-After` = "7"),
    body = list(message = "slow down")
  )
  err <- tryCatch(
    httr2::with_mocked_responses(
      list(fake_resp, fake_resp, fake_resp),
      dc_search(dc, "VN30")
    ),
    error = identity
  )
  expect_s3_class(err, "datacore_rate_limit_error")
  expect_match(conditionMessage(err), "rate limit|retry", ignore.case = TRUE)
})

test_that("dc_search input validation", {
  dc <- datacore_client(api_key = "dc_test")
  expect_error(dc_search(dc, ""))
  expect_error(dc_search(dc, "ok", limit = 0))
  expect_error(dc_search(NULL, "ok"))
})

test_that("dc_get validates dataset_id", {
  dc <- datacore_client(api_key = "dc_test")
  expect_error(dc_get(dc, ""))
  expect_error(dc_get(dc, NA_character_))
})
