# Set the active link of a nav from the server

Activates the
[`bs_nav_link()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md)
carrying `selected` as its `value` inside the
[`bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md)
registered under `id`, and reports the change back as `input$id`.

## Usage

``` r
update_bs_nav(id, selected = NULL, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- id:

  Nav id, as passed to
  [`bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md).

- selected:

  `value` of the link to activate.

- session:

  The Shiny session.

## Value

Nothing, called for its side effect.

## See also

[`bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md)

## Examples

``` r
if (interactive()) update_bs_nav("menu", selected = "profile")
```
