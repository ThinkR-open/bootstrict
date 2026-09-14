# Bootstrap checkbox group

Delegates to
[`shiny::checkboxGroupInput()`](https://rdrr.io/pkg/shiny/man/checkboxGroupInput.html)
and rewrites the markup to Bootstrap 5 `.form-check` shape so the value
stays available as `input$id`.

## Usage

``` r
bs_checkbox_group_input(
  id,
  label = NULL,
  choices,
  selected = NULL,
  ...,
  inline = FALSE,
  reverse = FALSE,
  help = NULL,
  width = NULL
)
```

## Arguments

- id:

  Input id; selected value available as `input$id`.

- label:

  Input label.

- choices:

  Named or unnamed vector / list of choices.

- selected:

  Initially selected value(s).

- ...:

  Extra attributes applied to each radio `<input>`.

- inline:

  If `TRUE`, lay the choices out horizontally.

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

[`shiny::checkboxGroupInput()`](https://rdrr.io/pkg/shiny/man/checkboxGroupInput.html)

## Examples

``` r
bs_checkbox_group_input("opts", "Options", c("A", "B", "C"), selected = "A")
#> <div id="opts" class="form-group shiny-input-checkboxgroup shiny-input-container" role="group" aria-labelledby="opts-label" data-bootstrict="form-check">
#>   <label class="control-label form-label" for="opts" id="opts-label">Options</label>
#>   <div class="shiny-options-group">
#>     <div class="form-check">
#>       <label class="form-check-label">
#>         <input type="checkbox" name="opts" value="A" checked="checked" class="form-check-input"/>
#>         <span>A</span>
#>       </label>
#>     </div>
#>     <div class="form-check">
#>       <label class="form-check-label">
#>         <input type="checkbox" name="opts" value="B" class="form-check-input"/>
#>         <span>B</span>
#>       </label>
#>     </div>
#>     <div class="form-check">
#>       <label class="form-check-label">
#>         <input type="checkbox" name="opts" value="C" class="form-check-input"/>
#>         <span>C</span>
#>       </label>
#>     </div>
#>   </div>
#> </div>
```
