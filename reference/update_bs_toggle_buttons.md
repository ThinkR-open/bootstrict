# Set the selection of a toggle button group from the server

Drives a
[`bs_radio_button_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_button_input.md)
or
[`bs_checkbox_button_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_button_input.md).
Pass `character(0)` to clear a checkbox group.

## Usage

``` r
update_bs_toggle_buttons(
  id,
  selected = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Input id.

- selected:

  Value(s) to select. A radio group keeps only the first.

- session:

  The Shiny session.

## Value

Nothing, called for its side effect.

## See also

[`bs_radio_button_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_button_input.md)

## Examples

``` r
if (interactive()) update_bs_toggle_buttons("size", selected = "l")
```
