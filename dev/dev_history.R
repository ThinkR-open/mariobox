
### Daily ----------------------------------------------------------------------

# Document and manage dependencies
attachment::att_amend_desc(
  extra.suggests = c(
    # Those packages are needed for test on pipeworkexample to work
    "plumber",
    "httr",
    "yaml",
    NULL
  )
)

.check_n_covr()

devtools::check()

devtools::test()

### Setup ----------------------------------------------------------------------

.use_r_with_test("create_pipework")
.use_r_with_test("utils")
.use_r_with_test("manage_endpoints")
