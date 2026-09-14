# Control a tabset from the server

Control a tabset from the server

## Usage

``` r
update_bs_tabset(id, selected, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- id:

  Tabset id (namespaced automatically inside modules).

- selected:

  Value of the panel to show.

- session:

  The Shiny session.

## Value

Invisibly `NULL`, called for its side effect.

## Examples

``` r
if (FALSE) { # \dontrun{
update_bs_tabset("tabs", selected = "profile")
} # }
```
