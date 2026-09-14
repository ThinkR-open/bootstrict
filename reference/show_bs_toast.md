# Control a toast from the server

Show or hide a
[`bs_toast()`](https://thinkr-open.github.io/bootstrict/reference/bs_toast.md)
from server code.

## Usage

``` r
show_bs_toast(id, session = shiny::getDefaultReactiveDomain())

hide_bs_toast(id, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- id:

  Toast id (namespaced automatically inside modules).

- session:

  The Shiny session.

## Value

Invisibly `NULL`, called for its side effect.

## Examples

``` r
if (interactive()) show_bs_toast("hello")
if (interactive()) hide_bs_toast("hello")
```
