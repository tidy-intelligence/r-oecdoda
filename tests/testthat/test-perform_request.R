test_that("to_filter_string returns a single string", {
  result <- to_filter_string(c("filter1", "filter2", "filter3"))
  expect_type(result, "character")
  expect_length(result, 1)
})

test_that("to_filter_string joins multiple filters with plus", {
  result <- to_filter_string(c("a", "b", "c"))
  expect_equal(result, "a+b+c")
})

test_that("to_filter_string works with a single filter", {
  result <- to_filter_string(c("only"))
  expect_equal(result, "only")
})

test_that("to_filter_string returns empty string for empty input", {
  result <- to_filter_string(character(0))
  expect_equal(result, "")
})

test_that("to_filter_string handles special characters correctly", {
  result <- to_filter_string(c("x+y", "z"))
  expect_equal(result, "x+y+z")
})
