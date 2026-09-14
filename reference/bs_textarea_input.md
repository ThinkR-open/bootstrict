# Bootstrap textarea input

Bootstrap textarea input

## Usage

``` r
bs_textarea_input(
  id,
  label = NULL,
  value = "",
  ...,
  placeholder = NULL,
  rows = NULL,
  cols = NULL,
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

- rows, cols:

  Visible rows / columns.

- size:

  Control size: `"sm"` or `"lg"`.

- help:

  Help text rendered below the control (`.form-text`).

- width:

  CSS width (e.g. `"100%"`, `"200px"`).

## Value

A form control tag.

## See also

[`shiny::textAreaInput()`](https://rdrr.io/pkg/shiny/man/textAreaInput.html)

## Examples

``` r
bs_textarea_input("bio", "Bio", rows = 3, placeholder = "A few words")
#> <div class="shiny-input-textarea form-group shiny-input-container">
#>   <label class="control-label form-label" for="bio" id="bio-label">Bio</label>
#>   <textarea id="bio" class="form-control" placeholder="A few words" rows="3" data-update-on="change"></textarea>
#> </div>
```
