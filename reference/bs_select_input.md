# Bootstrap select input

Renders a native Bootstrap 5 `<select class="form-select">` (selectize
is disabled to stay faithful to the Bootstrap markup).

## Usage

``` r
bs_select_input(
  id,
  label = NULL,
  choices = NULL,
  selected = NULL,
  ...,
  multiple = FALSE,
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

- choices:

  Named or unnamed vector / list of choices.

- selected:

  Initially selected value(s).

- ...:

  Extra attributes applied to the `<input>` element.

- multiple:

  Allow multiple selection.

- size:

  Control size: `"sm"` or `"lg"`.

- help:

  Help text rendered below the control (`.form-text`).

- width:

  CSS width (e.g. `"100%"`, `"200px"`).

## Value

A form control tag.

## See also

[`shiny::selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html)

## Examples

``` r
bs_select_input("fruit", "Fruit", c("Apple", "Pear"))
#> <div class="form-group shiny-input-container">
#>   <label class="control-label form-label" for="fruit" id="fruit-label">Fruit</label>
#>   <div>
#>     <select id="fruit" class="shiny-input-select form-select"><option value="Apple" selected>Apple</option>
#> <option value="Pear">Pear</option></select>
#>   </div>
#> </div>
```
