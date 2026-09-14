# Bootstrap date range input

Two native date fields joined in an `.input-group`, with a separator
between them. Bootstrap has no date-range component, so this is the
assembly its docs prescribe; see
[`bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_input.md)
for why neither field delegates to shiny.

## Usage

``` r
bs_date_range_input(
  id,
  label = NULL,
  start = NULL,
  end = NULL,
  ...,
  min = NULL,
  max = NULL,
  separator = "to",
  size = NULL,
  help = NULL,
  width = NULL
)
```

## Arguments

- id:

  Input id; selected value available as `input$id`.

- label:

  Input label.

- start, end:

  Initial start / end dates.

- ...:

  Extra attributes applied to each radio `<input>`.

- min, max:

  Earliest / latest selectable date.

- separator:

  Text shown between the two fields, in an `.input-group-text`.

- size:

  Control size: `"sm"` or `"lg"`.

- help:

  Help text rendered below the control (`.form-text`).

- width:

  CSS width (e.g. `"100%"`, `"200px"`).

## Value

A form control tag. `input$id` is a length-2 `Date`.

## See also

[`update_bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_date_input.md),
[`bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_input.md)

## Examples

``` r
bs_date_range_input("range", "Period", start = "2026-01-01")
#> <div id="range" data-bootstrict="date-range">
#>   <label class="form-label" id="range-label">Period</label>
#>   <div class="input-group">
#>     <input id="range-start" type="date" class="form-control" value="2026-01-01" aria-label="Start date"/>
#>     <span class="input-group-text">to</span>
#>     <input id="range-end" type="date" class="form-control" aria-label="End date"/>
#>   </div>
#> </div>
```
