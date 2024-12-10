is_properly_populated_mariobox <- function(path) {
  expected_files <- list.files(
    mariobox_sys(
      "marioboxexample"
    ),
    recursive = TRUE
  )

  expected_files <- expected_files[!grepl(
    "Rproj",
    expected_files
  )]
  expected_files <- expected_files[!grepl(
    "vscode-R",
    expected_files
  )]

  expected_files <- expected_files[!grepl(
    "REMOVEME.Rbuildignore",
    expected_files
  )]

  actual_files <- list.files(path, recursive = TRUE)
  actual_files <- actual_files[!grepl(
    "vscode-R",
    actual_files
  )]
  identical(
    sort(expected_files),
    sort(actual_files)
  )
}


test_that("copy_empty_mariobox works", {
  on.exit(
    {
      dir_remove(
        dummy_mariobox
      )
    },
    add = TRUE
  )
  dummy_mariobox <- create_dummy_mariobox()
  expect_true(
    is_properly_populated_mariobox(
      path = dummy_mariobox
    )
  )
})
