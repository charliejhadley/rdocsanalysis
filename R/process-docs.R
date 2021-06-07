#' Get docs for package
#'
#' This function gets all .Rd pages from a repo.
#'
#' @export
get_pkg_docs <- function(pkg_name, version_number) {
  pkg_dir <- clone_pkg_docs(pkg_name, version_number)
}

rd_section_pattern <- "[a-z]*\\{(?:[^{}]*|(?R))*\\}"

#' Process an .Rd file into a structured tibble
#'
#' This function takes a .Rd filepath and parses the file into a structured tibble.
#'
#' @export
process_rd_page <- function(rd_path) {
  rd_text <- paste0(readLines(rd_path), collapse = "")

  rd_text <- regmatches(rd_text, gregexpr(rd_section_pattern, rd_text, perl = TRUE))[[1]]

  rd_sections_df <- purrr::map_dfr(rd_text, ~ c(section_name = str_extract(.x, "^[a-z]*"), section_value = str_remove_all(.x, "(^[a-z]*[{])|([}]$)")))

  rd_sections_df <- dplyr::mutate(rd_sections_df,
    page_specific_section = ifelse(section_name == "section",
      TRUE,
      FALSE
    )
  )

  rd_sections_df <- dplyr::mutate(rd_sections_df,
    section_name = ifelse(page_specific_section == TRUE,
      section_value,
      section_name
    )
  )

  rd_sections_df <- dplyr::mutate(rd_sections_df,
    section_value = ifelse(page_specific_section == TRUE,
      lead(section_value),
      section_value
    )
  )

  dplyr::select(
    dplyr::filter(
      rd_sections_df,
      section_name != ""
    ),
    section_name, page_specific_section, section_value
  )
}


#' Parse all documentation in package into a structured tibble.
#'
#' @param pkg_name Package name, or more specifically the package repository
#' name on https://github.com/cran/
#'
#' @param version_number Historical versions of packages are stored as releases, by
#'  default this is NA and the current release will be cloned. For historical
#'  releases provide the package version number as a string.
#'
#' @param check_url Check if the URL exists or not. By default this is FALSE.
#'
#' @param verbose Add version_number to the output tibble.
#'
#' @export
process_pkg_docs <- function(pkg_name, version_number = NA, check_url = FALSE, verbose = FALSE) {
  cloned_pkg <- clone_pkg_docs(pkg_name, version_number, check_url = check_url)

  if (is.na(cloned_pkg)) {
    return(NA)
  }

  rd_files <- list.files(file.path(cloned_pkg, "man"), pattern = "[.]Rd", full.names = TRUE)

  parsed_rd_files <- dplyr::bind_rows(purrr::map(rd_files, ~ tibble::add_column(process_rd_page(.x),
    doc_page = basename(.x),
    .before = 0
  )))

  parsed_rd_files <- tibble::add_column(parsed_rd_files,
    pkg_name = pkg_name,
    .before = 0
  )

  if (verbose == TRUE) {
    parsed_rd_files <- tibble::add_column(parsed_rd_files,
      pkg_version = version_number,
      .after = 1
    )
  }

  parsed_rd_files
}
