test_that("Managing endpoints", {
  path_dummy <- tempfile(pattern = "dummy")
  dir.create(path_dummy)

  dummy_mariobox_path <- file.path(path_dummy, "pipo")
  path_pkg <- create_mariobox(
    path = dummy_mariobox_path,
    open = FALSE
  )

  withr::with_dir(dummy_mariobox_path, {
    # Adding endpoint
    mariobox_yaml_path <- "inst/mariobox.yml"
    endpoint_name <- "michel"
    r_file <- sprintf("R/fct_%s.R", endpoint_name)
    test_file <- sprintf("tests/testthat/test-fct_%s.R", endpoint_name)
    endpoint_fct_code_str <- sprintf("%s <- function(req){    return(\"ok\")}", endpoint_name)
    default_yaml <- list(
      handles = list(
        health = list(
          methods = "GET",
          path = "/health",
          handler = "health"
        )
      )
    )
    expected_yaml <- default_yaml
    expected_yaml[["handles"]][[endpoint_name]] <- list(
      methods = "GET",
      path = paste0("/", endpoint_name),
      handler = endpoint_name
    )

    add_endpoint(
      name = endpoint_name,
      open = FALSE
    )

    expect_true(file.exists(r_file))
    expect_true(file.exists(test_file))
    expect_equal(
      paste0(readLines(r_file), collapse = ""),
      endpoint_fct_code_str
    )
    expect_equal(
      paste0(readLines(test_file), collapse = ""),
      "test_that(\"multiplication works\", {  expect_equal(2 * 2, 4)})"
    )
    expect_equal(
      yaml::read_yaml(mariobox_yaml_path),
      expected_yaml
    )

    # Idempotence: Adding endpoint
    expect_message(
      add_endpoint(
        name = endpoint_name,
        open = FALSE
      ),
      regexp = sprintf("Endpoint '%s' already created", endpoint_name)
    )
    expect_true(file.exists(r_file))
    expect_true(file.exists(test_file))
    expect_equal(
      paste0(readLines(r_file), collapse = ""),
      endpoint_fct_code_str
    )
    expect_equal(
      paste0(readLines(test_file), collapse = ""),
      "test_that(\"multiplication works\", {  expect_equal(2 * 2, 4)})"
    )
    expect_equal(
      yaml::read_yaml(mariobox_yaml_path),
      expected_yaml
    )

    # Remove endpoint
    remove_endpoint(
      name = endpoint_name
    )
    expect_false(file.exists(r_file))
    expect_false(file.exists(test_file))
    expect_equal(
      yaml::read_yaml(mariobox_yaml_path),
      default_yaml
    )

    # Idempotence: Remove endpoint
    expect_message(
      remove_endpoint(
        name = endpoint_name
      ),
      regexp = sprintf("There is no endpoint '%s' to delete", endpoint_name)
    )
    expect_false(file.exists(r_file))
    expect_false(file.exists(test_file))
    expect_equal(
      yaml::read_yaml(mariobox_yaml_path),
      default_yaml
    )
  })

  dir_remove(path_dummy)
})
