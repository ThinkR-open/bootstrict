# Parse a SASS/SCSS variable sheet into a named list

Reads a `_variables.scss` style file (the kind a designer exports) and
extracts top-level `$name: value;` declarations into a named list
suitable for passing to
[`bootstrict_theme()`](https://thinkr-open.github.io/bootstrict/reference/bootstrict_theme.md)
or
[`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html).
Trailing `!default` / `!global` flags and line/block comments are
stripped. Values are returned verbatim as strings (Sass resolves them at
compile time), so maps, functions and colour expressions all pass
straight through.

## Usage

``` r
parse_scss_variables(path)
```

## Arguments

- path:

  Path to a `.scss` file (SCSS syntax, `$name: value;` — the indented
  `.sass` syntax has no semicolons and cannot be parsed).

## Value

A named list of Sass variable values. Names use the Bootstrap convention
without the leading `$` (e.g. `primary`, `font-family-base`).

## Details

The file is scanned rather than read line by line, so a declaration may
span as many lines as it likes (`$theme-colors`, `$grid-breakpoints` and
`$spacers` always do), and a `;`, `//` or `/* */` inside a quoted string
or an unquoted [`url()`](https://rdrr.io/r/base/connections.html) is
read as data. Anything that is not a top-level variable declaration —
`@use`/`@import`, a rule block — is ignored. A final declaration with no
trailing `;` is still read.

## Examples

``` r
tmp <- tempfile(fileext = ".scss")
writeLines(c("$primary: #ff6600;", "$border-radius: 0.5rem !default;"), tmp)
parse_scss_variables(tmp)
#> $primary
#> [1] "#ff6600"
#> 
#> $`border-radius`
#> [1] "0.5rem"
#> 
```
