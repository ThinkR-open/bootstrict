# Update a range input from the server

Routes through
[shiny::session](https://rdrr.io/pkg/shiny/man/session.html)'s
`sendInputMessage()` so the range binding's `receiveMessage` updates the
slider (the "shiny-like" update path).

## Usage

``` r
update_bs_range(id, value, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- id:

  Range input id (namespaced automatically inside modules).

- value:

  New value.

- session:

  The Shiny session.

## Value

Invisibly `NULL`, called for its side effect.

## Examples

``` r
if (interactive()) update_bs_range("vol", 75)
```
