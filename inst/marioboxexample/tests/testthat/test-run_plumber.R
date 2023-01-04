test_that("generate_api() works", {
  api <- generate_api()
  expect_s3_class(
    api,
    c("Plumber", "Hookable", "R6")
  )
  # The run() method is available within the object
  expect_equal(
    ls(api, pattern = "^run$"),
    "run"
  )
})
