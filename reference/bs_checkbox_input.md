# Bootstrap checkbox input

Bootstrap checkbox input

## Usage

``` r
bs_checkbox_input(
  id,
  label = NULL,
  value = FALSE,
  ...,
  switch = FALSE,
  reverse = FALSE,
  help = NULL,
  width = NULL
)

bs_switch_input(
  id,
  label = NULL,
  value = FALSE,
  ...,
  reverse = FALSE,
  help = NULL,
  width = NULL
)
```

## Arguments

- id:

  Input id; value available as `input$id`.

- label:

  Input label.

- value:

  Initial checked state.

- ...:

  Extra attributes applied to the `<input>` element.

- switch:

  If `TRUE`, render as a toggle switch (`.form-switch`).

- reverse:

  If `TRUE`, put the label before the control (`.form-check-reverse`,
  Bootstrap 5.2).

- help:

  Help text rendered below the control (`.form-text`).

- width:

  CSS width (e.g. `"100%"`, `"200px"`).

## Value

A form control tag.

## See also

[`shiny::checkboxInput()`](https://rdrr.io/pkg/shiny/man/checkboxInput.html)

## Examples

``` r
bs_checkbox_input("agree", "I agree", TRUE)
#> <div class="form-group shiny-input-container">
#>   <div class="form-check">
#>     <label class="form-check-label">
#>       <input checked="checked" class="shiny-input-checkbox form-check-input" id="agree" type="checkbox"/>
#>       <span>I agree</span>
#>     </label>
#>   </div>
#> </div>
bs_switch_input("dark", "Dark mode")
#> <div class="form-group shiny-input-container">
#>   <div class="form-check form-switch">
#>     <label class="form-check-label">
#>       <input class="shiny-input-checkbox form-check-input" id="dark" role="switch" type="checkbox"/>
#>       <span>Dark mode</span>
#>     </label>
#>   </div>
#> </div>
bs_checkbox_input("dark", "Dark mode", switch = TRUE)
#> <div class="form-group shiny-input-container">
#>   <div class="form-check form-switch">
#>     <label class="form-check-label">
#>       <input class="shiny-input-checkbox form-check-input" id="dark" role="switch" type="checkbox"/>
#>       <span>Dark mode</span>
#>     </label>
#>   </div>
#> </div>
```
