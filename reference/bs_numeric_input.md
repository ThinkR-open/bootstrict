# Bootstrap numeric input

Bootstrap numeric input

## Usage

``` r
bs_numeric_input(
  id,
  label = NULL,
  value = NULL,
  ...,
  min = NULL,
  max = NULL,
  step = NULL,
  size = NULL,
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

  Initial value.

- ...:

  Extra attributes applied to the `<input>` element.

- min, max, step:

  Numeric bounds and step.

- size:

  Control size: `"sm"` or `"lg"`.

- help:

  Help text rendered below the control (`.form-text`).

- width:

  CSS width (e.g. `"100%"`, `"200px"`).

## Value

A form control tag.

## See also

[`shiny::numericInput()`](https://rdrr.io/pkg/shiny/man/numericInput.html)

## Examples

``` r
bs_numeric_input("n", "How many?", value = 1, min = 0, max = 10)
#> <div class="form-group shiny-input-container">
#>   <label class="control-label form-label" for="n" id="n-label">How many?</label>
#>   <input id="n" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="10"/>
#> </div>
```
