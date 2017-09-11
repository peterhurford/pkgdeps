#' @export
get_deps <- memoise::memoise(function(pkg, suggests = FALSE) {
  which <- c("Depends", "Imports")
  if (isTRUE(suggests)) { which <- append(which, "Suggests") }
  tools::package_dependencies(pkg, db = package_data(), which = which)[[1]]
})

#' @export
get_recursive_deps <- function(pkgs) {
  initial_length <- length(pkgs)
  pkgs <- Reduce(union, lapply(pkgs, get_deps))
  new_length <- length(pkgs)
  if (new_length > initial_length) { pkgs <- get_recursive_deps(pkgs) }
  pkgs
}
