# Bootstrap colour input

A native `<input type="color" class="form-control form-control-color">`
whose value (a `"#rrggbb"` string) is reported as `input$id`. Drive it
server-side with
[`update_bs_color()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_color.md).

## Usage

``` r
bs_color_input(
  id,
  label = NULL,
  value = "#000000",
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

  Initial colour as a hex string (e.g. `"#0d6efd"`).

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
bs_color_input("col", "Pick a colour", value = "#0d6efd")
#> <div>
#>   <label class="form-label" for="col" id="col-label">Pick a colour</label>
#>   <input id="col" type="color" class="form-control form-control-color" value="#0d6efd" data-bootstrict="color"/>
#> </div>
```
