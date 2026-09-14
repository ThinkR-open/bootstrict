# The Bootstrap HTML dependency for a theme

Compiles `theme` against the vendored Bootstrap SASS tree and returns
the resulting stylesheet together with Bootstrap's JavaScript bundle.
The dependency is named `"bootstrap"` at the vendored version, so it
supersedes the Bootstrap 3 stylesheet Shiny's own page functions attach.

## Usage

``` r
bootstrap_dep(theme = bootstrict_theme())
```

## Arguments

- theme:

  A
  [`bootstrict_theme()`](https://thinkr-open.github.io/bootstrict/reference/bootstrict_theme.md).

## Value

An
[htmltools::htmlDependency](https://rstudio.github.io/htmltools/reference/htmlDependency.html).

## Details

[`bs_page()`](https://thinkr-open.github.io/bootstrict/reference/bs_page.md)
and friends call this for you; use it directly when building a page by
hand. Compiled stylesheets are cached per theme for the session.

## Examples

``` r
if (interactive()) {
  bootstrap_dep(bootstrict_theme(primary = "#ff6600"))
}
```
