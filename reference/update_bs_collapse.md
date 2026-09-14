# Control a collapse from the server

Show, hide or toggle a
[`bs_collapse()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse.md)
from server code.

## Usage

``` r
update_bs_collapse(
  id,
  action = c("toggle", "show", "hide"),
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Collapse id (namespaced automatically inside modules).

- action:

  One of `"toggle"`, `"show"` or `"hide"`.

- session:

  The Shiny session.

## Value

Invisibly `NULL`, called for its side effect.

## Examples

``` r
if (interactive()) update_bs_collapse("more", "show")
```
