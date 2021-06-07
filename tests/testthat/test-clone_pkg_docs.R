test_that("succesfully obtain current release of dplyr's docs", {
  cloned_dplyr <- clone_pkg_docs("dplyr")

  expect_true(dir.exists(file.path(cloned_dplyr, "man")))
})
