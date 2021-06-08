## code to prepare `DATASET` dataset goes here

usethis::use_data(DATASET, overwrite = TRUE)


## Initial code to get dplyr mutate docs

dplyr_rd_files <- process_pkg_docs("dplyr")
rd_file_mutate <- dplyr_rd_files[str_detect(dplyr_rd_files, "mutate.Rd")]

readLines(rd_file_mutate) %>%
  paste0(collapse = "\n") %>%
  writeLines("inst/exdata/mutate.Rd")
