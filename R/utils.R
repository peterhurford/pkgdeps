package_data <- memoise::memoise(function() available.packages())

packages_df <- function() { as.data.frame(package_data()) }
