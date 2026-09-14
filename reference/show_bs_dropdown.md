# Open, close or toggle a dropdown from the server

Drives the
[`bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md)
or
[`bs_nav_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav_dropdown.md)
registered under `id`. Its open state is reported back as `input$id`.

## Usage

``` r
show_bs_dropdown(id, session = shiny::getDefaultReactiveDomain())

hide_bs_dropdown(id, session = shiny::getDefaultReactiveDomain())

toggle_bs_dropdown(id, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- id:

  Dropdown id.

- session:

  The Shiny session.

## Value

Nothing, called for their side effect.

## See also

[`bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md)

## Examples

``` r
if (interactive()) {
  show_bs_dropdown("menu")
  hide_bs_dropdown("menu")
  toggle_bs_dropdown("menu")
}
```
