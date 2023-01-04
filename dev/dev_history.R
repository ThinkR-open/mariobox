
### Daily ----------------------------------------------------------------------

# Document and manage dependencies
attachment::att_amend_desc(
  extra.suggests = c(
    # Those packages are needed for test on marioboxexample to work
    "httr",
    # Extra dev dependencies
    "pkgload",
    NULL
  ), 
  pkg_ignore = c(
    # Extra dev dependencies
    "pkgload",
    NULL
  )
)

.check_n_covr()

devtools::check()

devtools::test()

### Setup ----------------------------------------------------------------------

.use_r_with_test("create_mariobox")
.use_r_with_test("utils")
.use_r_with_test("manage_endpoints")
