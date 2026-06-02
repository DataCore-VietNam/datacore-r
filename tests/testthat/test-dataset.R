test_that("dc_preview validates dataset_id", {
  expect_error(dc_preview(""))
  expect_error(dc_preview(NA_character_))
})

test_that("dc_preview invalid n is rejected", {
  expect_error(dc_preview("equity.vn30.daily", n = 0))
  expect_error(dc_preview("equity.vn30.daily", n = -1))
})

test_that("dc_get validates page and limit", {
  dc <- datacore_client(api_key = "dc_test")
  expect_error(dc_get(dc, "equity.vn30.daily", page = 0L))
  expect_error(dc_get(dc, "equity.vn30.daily", limit = 0L))
  expect_error(dc_get(dc, "equity.vn30.daily", page = -1L))
})

test_that("dc_get passes page and limit to request", {
  dc <- datacore_client(api_key = "dc_test")
  fake_body <- list(
    list(date = "2024-01-02", symbol = "VNM", close = 80.5)
  )
  fake_resp <- httr2::response_json(status_code = 200L, body = fake_body)
  result <- httr2::with_mocked_responses(
    list(fake_resp),
    dc_get(dc, "equity.vn30.daily", start = "2024-01-01", page = 2L, limit = 50L)
  )
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 1L)
})

test_that("dc_collect stops on empty page", {
  dc <- datacore_client(api_key = "dc_test")
  page1 <- list(
    list(date = "2024-01-02", symbol = "VNM", close = 80.5),
    list(date = "2024-01-03", symbol = "VNM", close = 81.0)
  )
  fake_p1 <- httr2::response_json(status_code = 200L, body = page1)
  fake_p2 <- httr2::response_json(status_code = 200L, body = list())
  result <- httr2::with_mocked_responses(
    list(fake_p1, fake_p2),
    dc_collect(dc, "equity.vn30.daily", limit = 2L, verbose = FALSE)
  )
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 2L)
})

test_that("dc_collect respects max_rows", {
  dc <- datacore_client(api_key = "dc_test")
  rows <- lapply(1:5, function(i) list(id = i, val = i * 10))
  fake_resp <- httr2::response_json(status_code = 200L, body = rows)
  result <- httr2::with_mocked_responses(
    list(fake_resp),
    dc_collect(dc, "equity.vn30.daily", limit = 5L, max_rows = 3L, verbose = FALSE)
  )
  expect_equal(nrow(result), 3L)
})

test_that("dc_download validates output_path", {
  dc <- datacore_client(api_key = "dc_test")
  expect_error(dc_download(dc, "equity.vn30.daily", output_path = ""))
  expect_error(dc_download(dc, "equity.vn30.daily", output_path = 123))
})

test_that("dc_download writes CSV and returns metadata", {
  dc <- datacore_client(api_key = "dc_test")
  rows <- list(
    list(date = "2024-01-02", symbol = "VNM", close = 80.5),
    list(date = "2024-01-03", symbol = "VNM", close = 81.0)
  )
  fake_p1 <- httr2::response_json(status_code = 200L, body = rows)
  fake_p2 <- httr2::response_json(status_code = 200L, body = list())
  tmp <- tempfile(fileext = ".csv")
  result <- httr2::with_mocked_responses(
    list(fake_p1, fake_p2),
    dc_download(dc, "equity.vn30.daily", output_path = tmp,
                limit = 2L, verbose = FALSE)
  )
  expect_identical(result$output_path, tmp)
  expect_equal(result$rows_downloaded, 2L)
  df <- utils::read.csv(tmp)
  expect_equal(nrow(df), 2L)
  unlink(tmp)
})
