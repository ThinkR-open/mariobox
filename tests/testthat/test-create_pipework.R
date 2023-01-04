
is_properly_populated_mariobox <- function(path) {
  # All files excepts *.Rproj which changes based on the project name
  expected_files <- c(
    "DESCRIPTION",
    "LICENSE",
    "LICENSE.md",
    "dev/run_dev.R",
    "inst/mariobox.yml",
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
dummy_mariobox_path <- file.path(path_dummy, "pipo")
path_pkg <- create_mariobox(
  path = dummy_mariobox_path,
  open = FALSE
)

usethis::with_project(dummy_mariobox_path, {
  test_that("create_mariobox() works", {
    usethis::use_mit_license(copyright_holder = "Babar")

    check_output <- rcmdcheck::rcmdcheck(
      # path = dummy_mariobox_path,
      quiet = TRUE,
      args = c("--no-manual")
    )

    expect_equal(
      check_output[["errors"]],
      character(0)
    )
    expect_lte(
      length(
        keep_only_non_pdf_related_warnings(check_output[["warnings"]])
      ),
      1
    )
    if (length(check_output[["warnings"]]) == 1) {
      expect_true(grepl("there is no package called", check_output[["warnings"]]))
    }
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
      is_properly_populated_mariobox(path_pkg)
    )
  })
})

dir_remove(path_dummy)
