# Bootstrap grid row

Bootstrap grid row

## Usage

``` r
bs_row(
  ...,
  cols = NULL,
  gutters = NULL,
  gx = NULL,
  gy = NULL,
  justify = NULL,
  align = NULL,
  class = NULL
)
```

## Arguments

- ...:

  Columns
  ([`bs_col()`](https://thinkr-open.github.io/bootstrict/reference/bs_col.md))
  and named HTML attributes.

- cols:

  Number of equal-width columns per row (`row-cols-*`). A single value
  applies at all breakpoints; a named list (e.g. `list(sm = 1, md = 2)`)
  sets per-breakpoint counts.

- gutters, gx, gy:

  Gutter width `0`-`5`. `gutters` sets both axes; `gx`/`gy` override the
  horizontal / vertical gutter.

- justify:

  Horizontal alignment of columns: `"start"`, `"center"`, `"end"`,
  `"around"`, `"between"`, `"evenly"`.

- align:

  Vertical alignment of columns: `"start"`, `"center"`, `"end"`.

- class:

  Extra classes.

## Value

A row tag.

## Examples

``` r
bs_row(bs_col("a"), bs_col("b"), gutters = 3)
#> <div class="row gx-3 gy-3">
#>   <div class="col">a</div>
#>   <div class="col">b</div>
#> </div>
```
