# Bootstrap range (slider) input

A native `<input type="range" class="form-range">` whose value is
reported to the server as `input$id`. Drive it server-side with
[`update_bs_range()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_range.md).

## Usage

``` r
bs_range_input(
  id,
  label = NULL,
  value = NULL,
  min = 0,
  max = 100,
  step = NULL,
  ...,
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

  Initial value. If `NULL`, the browser initializes the control at its
  midpoint (`(min + max) / 2`), which is what `input$id` reports.

- min, max, step:

  Numeric bounds and step.

- ...:

  Extra attributes applied to the `<input>` element.

- help:

  Help text rendered below the control (`.form-text`).

- width:

  CSS width (e.g. `"100%"`, `"200px"`).

## Value

A form control tag.

## Examples

``` r
bs_range_input("vol", "Volume", value = 50, min = 0, max = 100)
#> <div>
#>   <label class="form-label" for="vol" id="vol-label">Volume</label>
#>   <input id="vol" type="range" class="form-range" min="0" max="100" value="50" data-bootstrict="range"/>
#> </div>
```
