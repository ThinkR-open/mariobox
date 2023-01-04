#' @noRd
#' @importFrom utils file.edit
usethis_use_r <- function(
  name,
  pkg = ".",
  open = rlang::is_interactive()
) {
  rlang::check_installed(
    "fs",
    "to create R files"
  )
  name <- fs::path_abs(
    fs::path(
      pkg,
      "R",
      sprintf(
        "%s.R",
        name
      )
    )
  )
  fs::file_create(
    path = name
  )
  if (open) {
    file.edit(name)
  }
}
#' @noRd
#' @importFrom utils file.edit
usethis_use_test <- function(
  name = NULL,
  pkg = ".",
  open = rlang::is_interactive()
) {
  rlang::check_installed(
    "fs",
    "to create test files"
  )
  name <- fs::path_abs(
    fs::path(
      pkg,
      "tests",
      "testthat",
      sprintf(
        "test-%s.R",
        name
      )
    )
  )
  fs::file_create(
    path = name
  )
  write_there <- function(x) {
    write(x, file = name, append = TRUE)
  }
  write_there('test_that("multiplication works", {')
  write_there("  expect_equal(2 * 2, 4)")
  write_there("})")
  if (open) {
    file.edit(name)
  }
}

pkgload_load_all <- function(path = ".") {
  rlang::check_installed(
    "pkgload",
    "to build the plumber file"
  )
  pkgload::load_all(
    path = path
  )
}
