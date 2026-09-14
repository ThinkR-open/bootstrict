# Control a list group selection from the server

Activates the item whose `value` matches `selected` in a selectable
[`bs_list_group()`](https://thinkr-open.github.io/bootstrict/reference/bs_list_group.md)
(one created with an `id`).

## Usage

``` r
update_bs_list_group(
  id,
  selected = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  List group id (namespaced automatically inside modules).

- selected:

  Item value to activate. `NULL` (the default) leaves the current
  selection unchanged; `character(0)` clears it (deselects every item
  and resets `input$id` to `NULL`).

- session:

  The Shiny session.

## Value

Invisibly `NULL`, called for its side effect.

## Examples

``` r
if (FALSE) { # \dontrun{
update_bs_list_group("my_group", selected = "two")
update_bs_list_group("my_group", selected = character(0)) # clear
} # }
```
