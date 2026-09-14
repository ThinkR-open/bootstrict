# Update a colour input from the server

Routes through
[shiny::session](https://rdrr.io/pkg/shiny/man/session.html)'s
`sendInputMessage()` so the colour binding's `receiveMessage` updates
the swatch.

## Usage

``` r
update_bs_color(id, value, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- id:

  Colour input id (namespaced automatically inside modules).

- value:

  New colour as a hex string (e.g. `"#0d6efd"`).

- session:

  The Shiny session.

## Value

Invisibly `NULL`, called for its side effect.

## Examples

``` r
if (interactive()) update_bs_color("col", "#198754")
```
