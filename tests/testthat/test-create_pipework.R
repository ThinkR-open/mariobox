
is_properly_populated_pipework <- function(path) {

  # All files excepts *.Rproj which changes based on the project name
  expected_files <- c(
    "DESCRIPTION",
    "dev/run_dev.R",
    "inst/pipework.yml",
    "man/run_api.Rd",
    "NAMESPACE",
    "R/fct_health.R",
    "R/run_plumber.R",
    "tests/testthat.R",
    "tests/testthat/test-health.R",
    "tests/testthat/test-run_plumber.R"
  )

  if (rstudioapi::isAvailable()) {
    expected_files <- c(
      expected_files,
      paste0(basename(path), ".Rproj")
    )
  }

  actual_files <- list.files(path, recursive = TRUE)

  identical(sort(expected_files), sort(actual_files))
}

keep_only_non_pdf_related_warnings <- function(check_output_warnings) {
  grep(
    "pdf",
    check_output_warnings,
    ignore.case = TRUE,
    invert = TRUE,
    value = TRUE
  )
}

path_dummy <- tempfile(pattern = "dummy")
dir.create(path_dummy)
dummy_pipework_path <- file.path(path_dummy, "pipo")
path_pkg <- create_pipework(
  path = dummy_pipework_path,
  open = FALSE
)

usethis::with_project(dummy_pipework_path, {
  test_that("create_pipework() works", {
    check_output <- rcmdcheck::rcmdcheck(
      # path = dummy_pipework_path,
      quiet = TRUE,
      args = c("--no-manual")
    )

    expect_equal(
      check_output[["errors"]],
      character(0)
    )
    expect_length(
      keep_only_non_pdf_related_warnings(check_output[["warnings"]]),
      1
    )
    expect_true(
      grepl("license", check_output[["warnings"]][1])
    )
    expect_lte(
      length(check_output[["notes"]]),
      1
    )
    if (length(check_output[["notes"]]) == 1) {
      expect_true(
        grepl("\\.here", check_output[["notes"]][1])
      )
    }
    expect_true(
      is_properly_populated_pipework(path_pkg)
    )
  })
})

dir_remove(path_dummy)
