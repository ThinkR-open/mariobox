usethis_use_r <- function(
  name = NULL,
  open = rlang::is_interactive()
) {
  rlang::check_installed(
    "usethis",
    "to create R files"
  )
  usethis::use_r(
    name = name,
    open = open
  )
}
usethis_use_test <- function(
  name = NULL,
  open = rlang::is_interactive()
) {
  rlang::check_installed(
    "usethis",
    "to create test files"
  )
  usethis::use_test(
    name = name,
    open = open
  )
}
