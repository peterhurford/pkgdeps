#' Get dependencies for a package.
#'
#' @param pkg character. The name of the package to fetch dependencies for.
#' @param depends logical. Whether or not to fetch Imports / Depends dependencies. Defaults to
#'   TRUE.
#' @param suggests logical. Whether or not to fetch Suggests depedencies. Defaults to FALSE.
#' @param recursive logical. Whether to recursively fetch Imports / Depends subdependencies for
#'   all the fetched dependencies. Defaults to FALSE.
#' @param recursive_suggests logical. Whether to recursively fetch Suggests subdependices for
#'   all the fetched dependencies. This is very slow! Defaults to FALSE.
#' @param error_on_cran logical. Whether to raise an error if the package is not on CRAN (e.g.,
#'   it is a typo, or it is on Bioconductor). If FALSE, a warning will be raised instead.
#'   Defaults to FALSE.
#' @export
get_deps <- memoise::memoise(function(pkg, depends = TRUE, suggests = FALSE, recursive = FALSE, recursive_suggests = FALSE, error_on_cran = TRUE) {
  if (pkg %in% base_packages()) { NULL }
  else if (isTRUE(recursive)) {
    if (!isTRUE(depends)) { stop("Recursive requires depends = TRUE.") }
    if (isTRUE(suggests)) {
      if (isTRUE(recursive_suggests)) {
        get_recursive_deps(pkg, suggests = TRUE, error_on_cran = error_on_cran)
      } else {
        initial_deps <- get_deps(pkg, suggests = TRUE)
        get_recursive_deps(initial_deps, suggests = FALSE, error_on_cran = error_on_cran)
      }
    } else {
      get_recursive_deps(pkg, suggests = FALSE, error_on_cran = error_on_cran)
    }
  } else if (!(pkg %in% packages_df()$Package)) {
    error_msg <- paste("Package", pkg, "is not on CRAN.")
    if (isTRUE(error_on_cran)) { stop(error_msg) } else { warning(error_msg) }
    NULL
  } else {
    which <- c()
    if (isTRUE(depends)) { which <- append(which, c("Depends", "Imports")) }
    if (isTRUE(suggests)) { which <- append(which, "Suggests") }
    tools::package_dependencies(pkg, db = package_data(), which = which)[[1]]
  }
})

get_recursive_deps <- function(pkgs, suggests = FALSE, error_on_cran = TRUE) {
  initial_length <- length(pkgs)
  pkgs <- Reduce(union, lapply(pkgs, function(pkg) {
    deps <- get_deps(pkg, suggests = suggests, error_on_cran = error_on_cran)
    if (is.null(deps)) { pkg } else { c(deps, pkg) }
  }))
  new_length <- length(pkgs)
  if (new_length > initial_length) {
    pkgs <- get_recursive_deps(pkgs, suggests = suggests, error_on_cran = error_on_cran)
  }
  pkgs
}
