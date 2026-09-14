# Control an offcanvas from the server

Show, hide or toggle a
[`bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas.md)
from server code.

## Usage

``` r
show_bs_offcanvas(id, session = shiny::getDefaultReactiveDomain())

hide_bs_offcanvas(id, session = shiny::getDefaultReactiveDomain())

toggle_bs_offcanvas(id, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- id:

  Offcanvas id (namespaced automatically inside modules).

- session:

  The Shiny session.

## Value

Invisibly `NULL`, called for its side effect.

## Examples

``` r
if (interactive()) show_bs_offcanvas("menu")
if (interactive()) hide_bs_offcanvas("menu")
if (interactive()) toggle_bs_offcanvas("menu")
```
