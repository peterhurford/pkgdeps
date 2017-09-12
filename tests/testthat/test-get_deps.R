context("get_deps")

test_that("R base packages have no deps", {
  expect_null(get_deps("base"))
  expect_null(get_deps("methods"))
  expect_null(get_deps("utils"))
  expect_null(get_deps("graphics"))
})

test_that("packages that don't exist are errors", {
  expect_error(get_deps("pizzaIsNotOnCran"), "not on CRAN")
})

test_that("packages that are not on CRAN can also just be warnings", {
  expect_warning(deps <- get_deps("pizzaIsNotOnCran", error_on_cran = FALSE))
  expect_null(deps)
})

test_that("it fetches Depends and Imports", {
  expect_equal(get_deps("modelwordcloud"), c("methods", "graphics", "stats"))
  expect_equal(get_deps("devtools"), c("httr", "utils", "tools", "methods", "memoise", "whisker", "digest", "rstudioapi", "jsonlite", "stats", "git2r", "withr"))
})

test_that("it fetches Suggests", {
  expect_equal(get_deps("modelwordcloud", depends = FALSE, suggests = TRUE), "testthat")
  expect_equal(get_deps("modelwordcloud", depends = TRUE, suggests = TRUE),
               c("methods", "graphics", "stats", "testthat"))
  expect_equal(get_deps("devtools", depends = FALSE, suggests = TRUE),
               c("curl", "crayon", "testthat", "BiocInstaller", "Rcpp", "MASS", "rmarkdown",
                 "knitr", "hunspell", "lintr", "bitops", "roxygen2", "evaluate", "rversions",
                 "covr", "gmailr"))
})

test_that("it can fetch all dependencies recursively", {
   expect_equal(get_deps("devtools", recursive = TRUE),
                c("methods", "jsonlite", "tools", "mime", "curl", "openssl",
                  "R6", "httr", "utils", "digest", "memoise", "whisker", "rstudioapi",
                  "stats", "graphics", "git2r", "withr", "devtools"))
   expect_true(length(setdiff(get_deps("devtools"), get_deps("devtools", recursive = TRUE))) == 0)
   expect_true(length(setdiff(get_deps("devtools", recursive = TRUE), get_deps("devtools"))) > 0)
})

test_that("it can fetch depends + suggests for main package, then all dependencies recursively", {
  expect_equal(get_deps("modelwordcloud", suggests = TRUE, recursive = TRUE),
               c("methods", "graphics", "stats", "digest", "grDevices", "utils",
                 "crayon", "praise", "magrittr", "R6", "testthat"))
  expect_equal(get_deps("testthat", suggests = TRUE, recursive = TRUE),
               c("digest", "grDevices", "methods", "utils", "crayon", "praise",
                 "magrittr", "R6", "jsonlite", "tools", "mime", "curl", "openssl",
                 "httr", "memoise", "whisker", "rstudioapi", "stats", "graphics",
                 "git2r", "withr", "devtools", "lazyeval", "rex", "covr"))
})
