#' Clone package docs
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
#' @export
clone_pkg_docs <- function(pkg_name, version_number = NA,  check_url = FALSE){

  if(isTRUE(check_url)){

    repo_exists <- check_pkg_repo(pkg_name)

    if(!isTRUE(repo_exists)){
      return(NA)
    }
  }

  if(is.na(version_number)){

    repo_url <- paste0('https://github.com/cran/', pkg_name)

    clone_dir <- file.path(tempdir(), 'git_repo')
    unlink(clone_dir, recursive = TRUE)
    dir.create(file.path(tempdir(), 'git_repo'), recursive = TRUE)

    # initialise repo
    invisible(system(paste("cd", clone_dir, '; git init; git remote add origin', repo_url, ";")
    ))

    # sparse checkout
    invisible(system(paste("cd", clone_dir, '; git config core.sparseCheckout true; echo man/ >> .git/info/sparse-checkout')
    ))

    # pull
    invisible(system(paste("cd", clone_dir, '; git pull --depth=1 origin master'),
    ))

    clone_dir <- clone_dir

  } else {

    repo_url <- paste0('https://github.com/cran/', pkg_name)

    clone_dir <- file.path(tempdir(), 'git_repo')
    unlink(clone_dir, recursive = TRUE)
    dir.create(file.path(tempdir(), 'git_repo'), recursive = TRUE)

    # initialise repo
    invisible(system(paste("cd", clone_dir, '; git init; git remote add origin', repo_url, ";")
    ))

    # sparse checkout
    invisible(system(paste("cd", clone_dir, '; git config core.sparseCheckout true; echo man/ >> .git/info/sparse-checkout')
    ))

    # fetch tags (this does download the whole repo :/ )
    system(paste("cd", clone_dir, '; git fetch --tags'))

    # pull
    invisible(system(paste("cd", clone_dir, '; git checkout', version_number),
    ))

    clone_dir <- clone_dir


  }

  clone_dir

}
