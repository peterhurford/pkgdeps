## pkgdeps: Find CRAN dependencies for R packages the easy way!

Get all CRAN dependencies of a package, topologically sorted, from left-to-right.

```R
library(pkgdeps)

get_deps("testthat")
> [1] "digest"   "crayon"   "praise"   "magrittr" "R6"       "methods"
```

Get Suggests dependencies as well:

```R
get_deps("testthat", suggests = TRUE)
> [1] "digest"   "crayon"   "praise"   "magrittr" "R6"       "methods"  "devtools"
> [8] "withr"    "covr"
```

Also get recursive dependencies (all Imports + Depends + Suggests dependencies of the main package, and then all Imports + Depends subdependencies of each depenendency pacakge.

```R
get_deps("testthat", suggests = TRUE, recursive = TRUE)
>  [1] "digest"     "grDevices"  "methods"    "utils"      "crayon"
>  [6] "praise"     "magrittr"   "R6"         "jsonlite"   "tools"
>  [11] "mime"       "curl"       "openssl"    "httr"       "memoise"
>  [16] "whisker"    "rstudioapi" "stats"      "graphics"   "git2r"
>  [21] "withr"      "devtools"   "lazyeval"   "rex"        "covr"
```

Because these packages are topologically sorted, they should be suitable for installation with the depdencies handled:

```R
for (pkg in get_deps("testthat", suggests = TRUE, recursive = TRUE)) {
  install.packages(pkg, dependencies = FALSE)  
}
```

You can also get information on the dependencies:

```R
get_deps_data("testthat")
> [[1]]
> [[1]]$name
> [1] "testthat"

> [[1]]$version
> [1] "1.0.2"

> [[1]]$license
> [1] "MIT + file LICENSE"
```

This can be useful for getting data on all your dependencies (such as licenses):

```R
if (!require(devtools)) { install.packages("devtools"); library(devtools) }
install_github("robertzk/recombinator")  # Recombinator package turns nested lists to dataframes.
library(recombinator)
deps_df <- recombinator(get_deps_data(get_deps("testthat", suggests = TRUE, recursive = TRUE)))
head(deps_df)
>       name version            license
>       1   digest  0.6.12         GPL (>= 2)
>       2   crayon   1.3.2 MIT + file LICENSE
>       3   praise   1.0.0 MIT + file LICENSE
>       4 magrittr     1.5 MIT + file LICENSE
>       5       R6   2.2.2 MIT + file LICENSE
>       6 jsonlite     1.5 MIT + file LICENSE

write.csv(deps_df, "deps.csv")
```

(Ironically, this does not yet work for the `pkgdeps` package itself, because it is not yet on CRAN.)


### Installation

Because this package is not yet on CRAN, it must be installed via devtools:

```R
if (!require(devtools)) { install.packages("devtools"); library(devtools) }
install_github("peterhurford/pkgdeps")
```
