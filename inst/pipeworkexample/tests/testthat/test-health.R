test_that("health() works", {
  expect_equal(
    health(),
    "ok"
  )
  # TODO: Is this really necessary?
  # expect_equal(
  #   httr::status_code(
  #     httr::GET(
  #       sprintf("%s/health", Sys.getenv("APIURL"))
  #     )
  #   ),
  #   expected = 200
  # )
})
