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
    r_file <- sprintf("R/get_%s.R", endpoint_name)
    test_file <- sprintf("tests/testthat/test-get_%s.R", endpoint_name)
    default_yaml <- list(
      metadata = list(
        title = "mariobox API"
      ),
      handles = list(
        health_get = list(
          methods = "GET",
          path = "/health",
          handler = "get_health"
        )
      )
    )
    expected_yaml <- default_yaml
    expected_yaml[["handles"]][[paste0(endpoint_name, "_get")]] <- list(
      methods = "GET",
      path = paste0("/", endpoint_name),
      handler = paste0("get_", endpoint_name)
    )

    add_endpoint(
      name = endpoint_name,
      open = FALSE
    )

    expect_true(file.exists(r_file))
    expect_true(file.exists(test_file))
    r_file_text <- readLines(r_file)
    # The end point function exists
    expect_equal(
      sum(
        grepl("^get_michel <- function", r_file_text)
      ),
      1
    )
    # The business logic function exists
    expect_equal(
      sum(
        grepl("^get_michel_f <- function", r_file_text)
      ),
      1
    )
    expect_equal(
      paste0(readLines(test_file), collapse = ""),
      "test_that(\"multiplication works\", {  expect_equal(2 * 2, 4)})"
    )

    actual_yaml <- yaml::read_yaml(mariobox_yaml_path)
    expect_equal(
      actual_yaml,
      expected_yaml
    )

    # Idempotence: Adding endpoint
    expect_message(
      add_endpoint(
        name = endpoint_name,
        open = FALSE
      ),
      regexp = sprintf("Endpoint '%s' already exists", endpoint_name)
    )
    expect_true(file.exists(r_file))
    expect_true(file.exists(test_file))
    r_file_text <- readLines(r_file)
    # The end point function exists
    expect_equal(
      sum(
        grepl("^get_michel <- function", r_file_text)
      ),
      1
    )
    # The business logic function exists
    expect_equal(
      sum(
        grepl("^get_michel_f <- function", r_file_text)
      ),
      1
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
      name = endpoint_name,
      method = "GET"
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
        name = endpoint_name,
        method = "GET"
      ),
      regexp = sprintf("There is no endpoint '%s' with method 'GET' to delete", endpoint_name)
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
