# Create a Bootstrap 5.3 theme for a bootstrict UI

Collects SASS variable overrides – from a designer's exported sheet,
from `...`, or both – for
[`bootstrap_dep()`](https://thinkr-open.github.io/bootstrict/reference/bootstrap_dep.md)
to compile against the Bootstrap tree bootstrict vendors. Variables from
`variables` are merged with (and overridden by) any passed through
`...`.

## Usage

``` r
bootstrict_theme(..., variables = NULL)
```

## Arguments

- ...:

  Named SASS variables, e.g. `primary = "#ff6600"`. Names use the
  Bootstrap convention without the leading `$`.

- variables:

  Optional path to a `.scss` variable sheet, or a named list (as
  returned by
  [`parse_scss_variables()`](https://thinkr-open.github.io/bootstrict/reference/parse_scss_variables.md)).

## Value

A `bootstrict_theme` object.

## Details

Values are placed in the SASS layer that can actually compile them. A
value built only from literals or from the sheet's own variables
(`$primary: #ff6600`, `$link-color: $primary`) goes to the *defaults*
layer, where it is set before Bootstrap derives `$theme-colors` and the
rest from it. A value referring to one of Bootstrap's own variables
(`$link-hover-color: shade-color($primary, 20%)`, with no `$primary` in
the sheet) cannot go there – Bootstrap's variables are not defined yet –
so it goes to the *declarations* layer, after the configuration block.

One consequence is worth knowing: a theme colour redefined from one of
Bootstrap's own variables (`$secondary: $gray-600`) lands in the
declarations layer, after `$theme-colors` has been built, so it will not
restyle `.btn-secondary`. Give the sheet its own literal (or define the
variable it refers to) when that matters.

## Examples

``` r
bootstrict_theme(primary = "#ff6600", "font-size-base" = "1rem")
#> $defaults
#> $defaults$primary
#> [1] "#ff6600"
#> 
#> $defaults$`font-size-base`
#> [1] "1rem"
#> 
#> 
#> $declarations
#> named list()
#> 
#> attr(,"class")
#> [1] "bootstrict_theme"
```
