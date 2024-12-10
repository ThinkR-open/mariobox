test_that("silent_lapply() works", {
  expect_output(
    silent_lapply(
      letters,
      toupper
    ),
    regexp = NA
  )
  expect_equal(
    silent_lapply(
      letters,
      toupper
    ),
    as.list(LETTERS)
  )
})


test_that("replace_word replaces pattern correctly in a file", {
  temp_file <- tempfile()
  writeLines(c("Hello world", "Hello again"), temp_file)
  replace_word(temp_file, "Hello", "Hi")
  modified_content <- readLines(temp_file)
  expect_equal(modified_content, c("Hi world", "Hi again"))
  unlink(temp_file)
})

test_that("replace_word handles files with no matching pattern", {
  temp_file <- tempfile()
  writeLines(c("Goodbye world", "Goodbye again"), temp_file)
  replace_word(temp_file, "Hello", "Hi")
  modified_content <- readLines(temp_file)
  expect_equal(modified_content, c("Goodbye world", "Goodbye again"))
  unlink(temp_file)
})

test_that("replace_word works with empty files", {
  temp_file <- tempfile()
  file.create(temp_file)
  replace_word(temp_file, "Hello", "Hi")
  modified_content <- readLines(temp_file)
  expect_equal(modified_content, character(0))
  unlink(temp_file)
})

test_that("replace_word works with complex patterns", {
  temp_file <- tempfile()
  writeLines(c("abc123", "xyz789"), temp_file)
  replace_word(temp_file, "[a-z]{3}[0-9]{3}", "replaced")
  modified_content <- readLines(temp_file)
  expect_equal(modified_content, c("replaced", "replaced"))
  unlink(temp_file)
})
