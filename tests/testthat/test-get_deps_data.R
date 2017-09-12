context("get_deps_data")

test_that("it gets data for deps", {
  expect_equal(get_deps_data("modelwordcloud"),
               list(list(name = "modelwordcloud", version = "0.1", license = "LGPL-2.1")))
  deps <- get_deps_data(get_deps("modelwordcloud", suggests = TRUE, recursive = TRUE))
  for (dep in deps) {
    expect_is(dep, "list")
    expect_equal(names(dep), c("name", "version", "license"))
    expect_is(dep$name, "character")
    expect_is(dep$version, "character")
    expect_is(package_version(dep$version), "package_version")
    expect_is(dep$license, "character")
  }
})
