#' Test if package exists.
#'
#' This function checks if the package exists as a repo in this organisation: https://github.com/cran.
#'
#' @param pkg_name
#'
#' @details
#'
#' This function is not exported because it does not provide useful information. The function simply checks for if https://github.com/cran/pkg_name gives a 404 error or not. The repo includes packages that are no longer on CRAN (and could be years old!).
check_pkg_repo <- function(pkg_name){
  RCurl::url.exists(paste0('https://github.com/cran/', pkg_name))
}
