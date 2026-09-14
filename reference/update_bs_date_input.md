# Set a date input from the server

The native counterpart of
[`shiny::updateDateInput()`](https://rdrr.io/pkg/shiny/man/updateDateInput.html),
which cannot reach these controls.

## Usage

``` r
update_bs_date_input(
  id,
  value = NULL,
  min = NULL,
  max = NULL,
  session = shiny::getDefaultReactiveDomain()
)

update_bs_date_range_input(
  id,
  start = NULL,
  end = NULL,
  min = NULL,
  max = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Input id.

- value:

  New date, or `NA` to clear the field.

- min, max:

  New bounds.

- session:

  The Shiny session.

- start, end:

  New start / end dates, or `NA` to clear either field.

## Value

Nothing, called for its side effect.

## See also

[`bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_input.md)

## Examples

``` r
if (interactive()) update_bs_date_input("day", value = Sys.Date())
```
