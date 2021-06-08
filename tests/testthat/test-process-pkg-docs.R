# Test that process_rd_page() parses an .Rd file into a tibble
test_that("process_rd_page() parses an the mutate.Rd file into a tibble", {

  parsed_rd_page <- process_rd_page(system.file("exdata","mutate.Rd", package = "rdocsanalysis"))

  # This is a bad test because the mutate.Rd script might grow in size.
  expect_true(nrow(parsed_rd_page) == 15)
})

test_that("process_pkg_docs() processes all docs in a package"){

  parsed_dplyr_docs <- process_pkg_docs("dplyr")

  # This is a bad test because the mutate.Rd script might grow in size.
  expect_true(nrow(parsed_dplyr_docs) == 1087)

}

test_that("obtain old releases of dplyr", {


  dplyr_1_0_0 <- process_pkg_docs("dplyr", version_number = "1.0.0")

  dplyr_0_3 <- process_pkg_docs("dplyr", version_number = "0.3")

  expect_equal(nrow(dplyr_1_0_0), 1075)
  expect_equal(nrow(dplyr_0_3), 802)


})
