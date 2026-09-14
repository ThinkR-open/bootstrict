# Control an accordion from the server

Control an accordion from the server

## Usage

``` r
update_bs_accordion(
  id,
  open = NULL,
  close = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Accordion id (namespaced automatically inside modules).

- open:

  Panel value(s) to open. Use `TRUE` to open all (sensible with
  `multiple = TRUE`); `FALSE`/`NULL` is a no-op.

- close:

  Panel value(s) to close. Use `TRUE` to close all; `FALSE`/`NULL` is a
  no-op.

- session:

  The Shiny session.

## Value

Invisibly `NULL`, called for its side effect.

## Examples

``` r
if (interactive()) {
  update_bs_accordion("acc", open = "two")
  update_bs_accordion("acc", close = TRUE)
}
```
