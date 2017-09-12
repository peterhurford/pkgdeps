#' Get package data (name, version, license) for given dependencies.
#' @param pkgs character. A character vector of package names to fetch data for.
#' @return a list of named lists containing package name, version, and license for each package.
#' @export
get_deps_data <- function(pkgs) {
  package_df <- as.data.frame(package_data())
  rownames(package_df) <- NULL
  results <- lapply(pkgs, function(pkg) {
    data <- package_df[package_df$Package == pkg, ]
    if (nrow(data) == 0) { NULL }
    else { list(name = pkg, version = as.character(data$Version), license = as.character(data$License)) }
  })
  Filter(Negate(is.null), results)
}
