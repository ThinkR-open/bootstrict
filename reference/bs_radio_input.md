# Bootstrap radio button group

Delegates to
[`shiny::radioButtons()`](https://rdrr.io/pkg/shiny/man/radioButtons.html)
and rewrites the markup to Bootstrap 5 `.form-check` shape so the value
stays available as `input$id`.

## Usage

``` r
bs_radio_input(
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

  Initially selected value.

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

[`shiny::radioButtons()`](https://rdrr.io/pkg/shiny/man/radioButtons.html)

## Examples

``` r
bs_radio_input("size", "Size", c("S", "M", "L"), selected = "M")
#> <div id="size" class="form-group shiny-input-radiogroup shiny-input-container" role="radiogroup" aria-labelledby="size-label" data-bootstrict="form-check">
#>   <label class="control-label form-label" for="size" id="size-label">Size</label>
#>   <div class="shiny-options-group">
#>     <div class="form-check">
#>       <label class="form-check-label">
#>         <input type="radio" name="size" value="S" class="form-check-input"/>
#>         <span>S</span>
#>       </label>
#>     </div>
#>     <div class="form-check">
#>       <label class="form-check-label">
#>         <input type="radio" name="size" value="M" checked="checked" class="form-check-input"/>
#>         <span>M</span>
#>       </label>
#>     </div>
#>     <div class="form-check">
#>       <label class="form-check-label">
#>         <input type="radio" name="size" value="L" class="form-check-input"/>
#>         <span>L</span>
#>       </label>
#>     </div>
#>   </div>
#> </div>
```
