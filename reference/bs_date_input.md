# Bootstrap date input

A native `<input type="date">` with the Bootstrap `.form-control` class,
as the Bootstrap 5.3 forms reference has it: the browser supplies the
calendar.

## Usage

``` r
bs_date_input(
  id,
  label = NULL,
  value = NULL,
  ...,
  min = NULL,
  max = NULL,
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

- value:

  Initial date (a `Date` or `"yyyy-mm-dd"` string), or `NULL` for an
  empty field.

- ...:

  Extra attributes applied to each radio `<input>`.

- min, max:

  Earliest / latest selectable date.

- size:

  Control size: `"sm"` or `"lg"`.

- help:

  Help text rendered below the control (`.form-text`).

- width:

  CSS width (e.g. `"100%"`, `"200px"`).

## Value

A form control tag.

## Details

This does **not** delegate to
[`shiny::dateInput()`](https://rdrr.io/pkg/shiny/man/dateInput.html),
which loads `bootstrap-datepicker` – a third-party stylesheet whose
calendar markup (`.datepicker`, `.datepicker-days`, ...) appears nowhere
in the Bootstrap documentation and which a designer's SASS sheet cannot
reach. The consequence is that `format`, `language`, `weekstart` and
`datesdisabled` are gone: the browser owns the presentation, and there
is no Bootstrap way to ask it for another. Use
[`update_bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_date_input.md)
rather than
[`shiny::updateDateInput()`](https://rdrr.io/pkg/shiny/man/updateDateInput.html).

## See also

[`update_bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_date_input.md),
[`bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_range_input.md)

## Examples

``` r
bs_date_input("day", "Pick a day", value = "2026-06-26")
#> <div id="day" data-bootstrict="date">
#>   <label class="form-label" for="day-field" id="day-label">Pick a day</label>
#>   <input id="day-field" type="date" class="form-control" value="2026-06-26"/>
#> </div>
```
