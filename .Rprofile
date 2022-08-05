
if (file.exists("~/.Rprofile")) {
  cli::cat_rule("[Rprofile] Sourcing user rprofile")
  source("~/.Rprofile")
}

cli::cat_rule("[Rprofile] Sourcing project-wide rprofile")

### Custom project helper functions --------------------------------------------

.use_r_with_test <- function(name) {
  usethis::use_r(name)
  usethis::use_test(name)
}

.check_n_covr <- function() {
  res <- devtools::check(args = c("--no-tests"))
  print(res)
  covr::package_coverage(type = "tests", quiet = TRUE)
}

### Linter ---------------------------------------------------------------------

options(styler.cache_root = "styler-perm")

if (!rlang::is_installed("grkstyle")) {
  cli::cli_alert_danger("{grkstyle} styler not found!")
  cli::cat_line("- Please git clone and install the pkg from:")
  cli::cat_line("https://tfs-prd/Private%20Banking/SalesMarketing/_git/grkstyle/")
}
try({
  grkstyle::use_grk_style()
  grkstyle::grk_style_pkg()
})
