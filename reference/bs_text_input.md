# Bootstrap text input

Bootstrap text input

## Usage

``` r
bs_text_input(
  id,
  label = NULL,
  value = "",
  ...,
  placeholder = NULL,
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

- placeholder:

  Placeholder text.

- size:

  Control size: `"sm"` or `"lg"`.

- help:

  Help text rendered below the control (`.form-text`).

- width:

  CSS width (e.g. `"100%"`, `"200px"`).

## Value

A form control tag.

## See also

[`shiny::textInput()`](https://rdrr.io/pkg/shiny/man/textInput.html)

## Examples

``` r
bs_text_input("name", "Your name", placeholder = "Jane Doe")
#> <div class="form-group shiny-input-container">
#>   <label class="control-label form-label" for="name" id="name-label">Your name</label>
#>   <input id="name" type="text" class="shiny-input-text form-control" value="" placeholder="Jane Doe" data-update-on="change"/>
#> </div>
```
