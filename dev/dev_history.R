
### Daily ----------------------------------------------------------------------

# Document and manage dependencies
attachment::att_amend_desc()

devtools::check()

devtools::test()

### Setup ----------------------------------------------------------------------

.use_r_with_test("create_pipework")
.use_r_with_test("utils")
.use_r_with_test("manage_endpoints")
