test_that("silent_lapply() works", {
  expect_output(
    silent_lapply(
      letters,
      toupper
    ),
    regexp = NA
  )
  expect_equal(
    silent_lapply(
      letters,
      toupper
    ),
    as.list(LETTERS)
  )
})
