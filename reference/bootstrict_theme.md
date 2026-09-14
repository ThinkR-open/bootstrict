# Create a Bootstrap 5 theme for a bootstrict UI

A thin wrapper around
[`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
pinned to Bootstrap 5 that also accepts a designer's exported SASS
variable sheet. Variables from `variables` are merged with (and
overridden by) any variables passed through `...`, then handed to
`bslib`.

## Usage

``` r
bootstrict_theme(..., variables = NULL, bootswatch = NULL, preset = NULL)
```

## Arguments

- ...:

  Sass variables / arguments forwarded to
  [`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html).
  Named values like `primary = "#ff6600"` override Bootstrap defaults.

- variables:

  Optional path to a `.scss` variable sheet, or a named list (as
  returned by
  [`parse_scss_variables()`](https://thinkr-open.github.io/bootstrict/reference/parse_scss_variables.md)).

- bootswatch, preset:

  Optional Bootswatch / preset name (see
  [`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)).

## Value

A
[`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
object.

## Details

Values are placed in the Sass layer that can actually compile them. A
value built only from literals or from the sheet's own variables
(`$primary: #ff6600`, `$link-color: $primary`) goes to the *defaults*
layer, where it is set before Bootstrap derives `$theme-colors` and the
rest from it. A value referring to one of Bootstrap's own variables
(`$link-hover-color: shade-color($primary, 20%)`, with no `$primary` in
the sheet) cannot go there — Bootstrap's variables are not defined yet —
so it goes to the *declarations* layer, which `bslib` provides for
exactly that.

One consequence is worth knowing: a theme colour redefined from one of
Bootstrap's own variables (`$secondary: $gray-600`) lands in the
declarations layer, after `$theme-colors` has been built, so it will not
restyle `.btn-secondary`. Give the sheet its own literal (or define the
variable it refers to) when that matters.

## Examples

``` r
if (interactive()) {
  bootstrict_theme(primary = "#ff6600", "font-size-base" = "1rem")
}
```
