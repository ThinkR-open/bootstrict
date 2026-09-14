# The bootstrict HTML dependency (Shiny input bindings + supporting CSS)

Loads every JavaScript file shipped in `inst/assets/js`, forcing
`bootstrict-core.js` first (it defines the `window.bootstrict` namespace
that the per-component binding files rely on), followed by the
supporting stylesheet. Component binding files are discovered
dynamically, so adding a new binding is just a matter of dropping a
`.js` file in that directory. The dependency is built once per session
and cached (every widget calls this, and the installed files cannot
change mid-session).

## Usage

``` r
bootstrict_dep()
```

## Value

An
[htmltools::htmlDependency](https://rstudio.github.io/htmltools/reference/htmlDependency.html).

## Examples

``` r
bootstrict_dep()
#> List of 10
#>  $ name      : chr "bootstrict"
#>  $ version   : chr "0.9.9.9000"
#>  $ src       :List of 1
#>   ..$ file: chr "/home/runner/work/_temp/Library/bootstrict/assets"
#>  $ meta      : NULL
#>  $ script    : chr [1:22] "js/bootstrict-core.js" "js/binding-accordion.js" "js/binding-alert.js" "js/binding-behaviors.js" ...
#>  $ stylesheet: chr "css/bootstrict.css"
#>  $ head      : NULL
#>  $ attachment: NULL
#>  $ package   : NULL
#>  $ all_files : logi FALSE
#>  - attr(*, "class")= chr "html_dependency"
```
