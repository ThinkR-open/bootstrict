# Control a modal from the server

Show, hide or toggle a
[`bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
from server code.

## Usage

``` r
show_bs_modal(id, session = shiny::getDefaultReactiveDomain())

hide_bs_modal(id, session = shiny::getDefaultReactiveDomain())

toggle_bs_modal(id, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- id:

  Modal id (namespaced automatically inside modules).

- session:

  The Shiny session.

## Value

Invisibly `NULL`, called for its side effect.

## Examples

``` r
if (interactive()) show_bs_modal("info")
if (interactive()) hide_bs_modal("info")
if (interactive()) toggle_bs_modal("info")
```
