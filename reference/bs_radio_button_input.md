# Bootstrap toggle button groups

The segmented control from the Bootstrap "Button group" page: a row of
buttons backed by hidden radio or checkbox inputs (`.btn-check`).
`bs_radio_button_input()` picks one value, `bs_checkbox_button_input()`
picks any number.

## Usage

``` r
bs_radio_button_input(
  id,
  label = NULL,
  choices,
  selected = NULL,
  ...,
  color = "primary",
  outline = TRUE,
  size = NULL,
  vertical = FALSE,
  class = NULL
)

bs_checkbox_button_input(
  id,
  label = NULL,
  choices,
  selected = NULL,
  ...,
  color = "primary",
  outline = TRUE,
  size = NULL,
  vertical = FALSE,
  class = NULL
)
```

## Arguments

- id:

  Input id; the selection is available as `input$id` (a single string
  for radio buttons, a character vector — possibly empty — for
  checkboxes).

- label:

  Label shown above the group, or `NULL` for none.

- choices:

  Character vector of values. Names, when present, are used as the
  button labels.

- selected:

  Initially selected value(s). Defaults to the first choice for radio
  buttons and to none for checkboxes.

- ...:

  Named HTML attributes applied to the `.btn-group`.

- color:

  Button theme colour.

- outline:

  If `TRUE` (the default, as in the Bootstrap examples), outline buttons
  (`.btn-outline-*`).

- size:

  Button size: `"sm"` or `"lg"`.

- vertical:

  If `TRUE`, stack the buttons (`.btn-group-vertical`).

- class:

  Extra classes for the `.btn-group`.

## Value

A form control tag.

## Details

These are native controls, not restyled shiny inputs, so drive them with
[`update_bs_toggle_buttons()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_toggle_buttons.md)
rather than
[`shiny::updateRadioButtons()`](https://rdrr.io/pkg/shiny/man/updateRadioButtons.html).

## See also

[`update_bs_toggle_buttons()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_toggle_buttons.md),
[`bs_button_group()`](https://thinkr-open.github.io/bootstrict/reference/bs_button_group.md)

## Examples

``` r
bs_radio_button_input("size", "Size", c(Small = "s", Large = "l"))
#> <div id="size" data-bootstrict="toggle-buttons" data-bootstrict-type="radio">
#>   <label class="form-label" id="size-label">Size</label>
#>   <div class="btn-group" role="group" aria-labelledby="size-label">
#>     <input type="radio" class="btn-check" name="size" id="size-1" value="s" autocomplete="off" checked/>
#>     <label class="btn btn-outline-primary" for="size-1">Small</label>
#>     <input type="radio" class="btn-check" name="size" id="size-2" value="l" autocomplete="off"/>
#>     <label class="btn btn-outline-primary" for="size-2">Large</label>
#>   </div>
#> </div>
bs_checkbox_button_input("opts", "Options", c("a", "b"))
#> <div id="opts" data-bootstrict="toggle-buttons" data-bootstrict-type="checkbox">
#>   <label class="form-label" id="opts-label">Options</label>
#>   <div class="btn-group" role="group" aria-labelledby="opts-label">
#>     <input type="checkbox" class="btn-check" name="opts" id="opts-1" value="a" autocomplete="off"/>
#>     <label class="btn btn-outline-primary" for="opts-1">a</label>
#>     <input type="checkbox" class="btn-check" name="opts" id="opts-2" value="b" autocomplete="off"/>
#>     <label class="btn btn-outline-primary" for="opts-2">b</label>
#>   </div>
#> </div>
```
