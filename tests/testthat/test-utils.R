test_that("records_to_tibble handles empty / NULL input", {
  expect_equal(nrow(datacore:::records_to_tibble(NULL)), 0L)
  expect_equal(nrow(datacore:::records_to_tibble(list())), 0L)
})

test_that("records_to_tibble fills missing fields with NA", {
  recs <- list(
    list(a = 1, b = "x"),
    list(a = 2),
    list(a = 3, b = "z", c = TRUE)
  )
  df <- datacore:::records_to_tibble(recs)
  expect_s3_class(df, "tbl_df")
  expect_equal(nrow(df), 3L)
  expect_equal(df$a, c(1, 2, 3))
  expect_true(is.na(df$b[2]))
  expect_true(all(c("a", "b", "c") %in% names(df)))
})

test_that("records_to_tibble preserves first-seen column order", {
  recs <- list(
    list(z = 1, a = 2),
    list(a = 3, z = 4, m = 5)
  )
  df <- datacore:::records_to_tibble(recs)
  expect_equal(names(df), c("z", "a", "m"))
})

test_that("format_symbols joins vectors and drops empties", {
  expect_null(datacore:::format_symbols(NULL))
  expect_null(datacore:::format_symbols(character()))
  expect_identical(datacore:::format_symbols(c("VNM", "VIC")), "VNM,VIC")
  expect_identical(datacore:::format_symbols(c("VNM", "", "VIC")), "VNM,VIC")
})

test_that("format_date accepts Date, POSIXt, and string", {
  expect_null(datacore:::format_date(NULL))
  expect_identical(datacore:::format_date(as.Date("2024-01-15")), "2024-01-15")
  expect_identical(
    datacore:::format_date(as.POSIXct("2024-01-15 09:30:00", tz = "UTC")),
    "2024-01-15"
  )
  expect_identical(datacore:::format_date("2024-01-15"), "2024-01-15")
  expect_error(datacore:::format_date(20240115))
})

test_that("drop_nulls removes NULL elements only", {
  expect_equal(datacore:::drop_nulls(list(a = 1, b = NULL, c = "x")),
               list(a = 1, c = "x"))
  expect_equal(datacore:::drop_nulls(list(a = NA, b = NULL)),
               list(a = NA))
})

test_that("mask_key keeps short keys fully masked", {
  expect_equal(datacore:::mask_key(""), "<unset>")
  expect_equal(datacore:::mask_key("abcd"), "****")
  m <- datacore:::mask_key("dc_supersecret123")
  expect_true(startsWith(m, "dc_s"))
  expect_true(endsWith(m, "t123"))
})
