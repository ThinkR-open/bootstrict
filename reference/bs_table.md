# Bootstrap table

Render a faithful Bootstrap 5 `<table class="table">`. Pass a data frame
or matrix in `data` to have the header and body built automatically from
its column names and rows; otherwise supply `<thead>`/`<tbody>` markup
(or any table children) through `...`.

## Usage

``` r
bs_table(
  data = NULL,
  ...,
  striped = FALSE,
  bordered = FALSE,
  borderless = FALSE,
  hover = FALSE,
  small = FALSE,
  variant = NULL,
  responsive = FALSE,
  align = NULL,
  caption = NULL,
  caption_top = FALSE,
  head_variant = NULL,
  group_divider = FALSE,
  row_variant = NULL,
  rownames = NULL,
  class = NULL
)
```

## Arguments

- data:

  A data frame or matrix to render. When `NULL`, the unnamed `...`
  arguments are used as the table's children instead.

- ...:

  Manual table children (when `data` is `NULL`) and named HTML
  attributes applied to the `<table>` element.

- striped:

  Zebra-striping: `TRUE` or `"rows"` for `.table-striped`, `"columns"`
  for `.table-striped-columns`.

- bordered:

  Add borders on all sides (`.table-bordered`).

- borderless:

  Remove all borders (`.table-borderless`).

- hover:

  Enable a hover state on rows (`.table-hover`).

- small:

  Make the table more compact (`.table-sm`).

- variant:

  Theme colour for the whole table (`.table-*`), one of the Bootstrap
  theme colours.

- responsive:

  Make the table scroll horizontally on small devices. Use `TRUE` for
  `.table-responsive`, or a breakpoint string (`"sm"`, `"md"`, `"lg"`,
  `"xl"`, `"xxl"`) for `.table-responsive-{bp}`.

- align:

  Vertical alignment of cells (`.align-*`), e.g. `"middle"`, `"top"`,
  `"bottom"`.

- caption:

  Optional table caption text rendered in a `<caption>`.

- caption_top:

  If `TRUE`, place the caption above the table (`.caption-top`).

- head_variant:

  Theme colour for the generated `<thead>` (`.table-light`,
  `.table-dark`, or any theme colour).

- group_divider:

  If `TRUE`, add a thicker border between the header and the body
  (`.table-group-divider` on the generated `<tbody>`).

- row_variant:

  Per-row theme colour for the generated rows (`.table-*` on the
  `<tr>`). A character vector recycled to the number of rows; `NA`
  leaves a row unstyled. `"active"` is also accepted.

- rownames:

  Render each row's name as the reference `<th scope="row">` header
  cell. `NULL` (the default) does so when `data` carries real row names,
  as `mtcars` does; `TRUE` forces it (numbering the rows when there are
  no names, like Bootstrap's own example); `FALSE` never does.

- class:

  Extra classes.

## Value

A table tag (wrapped in a responsive container when `responsive` is
set).

## Examples

``` r
bs_table(head(mtcars), striped = TRUE, hover = TRUE)
#> <table class="table table-striped table-hover">
#>   <thead>
#>     <tr>
#>       <th scope="col"></th>
#>       <th scope="col">mpg</th>
#>       <th scope="col">cyl</th>
#>       <th scope="col">disp</th>
#>       <th scope="col">hp</th>
#>       <th scope="col">drat</th>
#>       <th scope="col">wt</th>
#>       <th scope="col">qsec</th>
#>       <th scope="col">vs</th>
#>       <th scope="col">am</th>
#>       <th scope="col">gear</th>
#>       <th scope="col">carb</th>
#>     </tr>
#>   </thead>
#>   <tbody>
#>     <tr>
#>       <th scope="row">Mazda RX4</th>
#>       <td>21</td>
#>       <td>6</td>
#>       <td>160</td>
#>       <td>110</td>
#>       <td>3.9</td>
#>       <td>2.62</td>
#>       <td>16.46</td>
#>       <td>0</td>
#>       <td>1</td>
#>       <td>4</td>
#>       <td>4</td>
#>     </tr>
#>     <tr>
#>       <th scope="row">Mazda RX4 Wag</th>
#>       <td>21</td>
#>       <td>6</td>
#>       <td>160</td>
#>       <td>110</td>
#>       <td>3.9</td>
#>       <td>2.875</td>
#>       <td>17.02</td>
#>       <td>0</td>
#>       <td>1</td>
#>       <td>4</td>
#>       <td>4</td>
#>     </tr>
#>     <tr>
#>       <th scope="row">Datsun 710</th>
#>       <td>22.8</td>
#>       <td>4</td>
#>       <td>108</td>
#>       <td>93</td>
#>       <td>3.85</td>
#>       <td>2.32</td>
#>       <td>18.61</td>
#>       <td>1</td>
#>       <td>1</td>
#>       <td>4</td>
#>       <td>1</td>
#>     </tr>
#>     <tr>
#>       <th scope="row">Hornet 4 Drive</th>
#>       <td>21.4</td>
#>       <td>6</td>
#>       <td>258</td>
#>       <td>110</td>
#>       <td>3.08</td>
#>       <td>3.215</td>
#>       <td>19.44</td>
#>       <td>1</td>
#>       <td>0</td>
#>       <td>3</td>
#>       <td>1</td>
#>     </tr>
#>     <tr>
#>       <th scope="row">Hornet Sportabout</th>
#>       <td>18.7</td>
#>       <td>8</td>
#>       <td>360</td>
#>       <td>175</td>
#>       <td>3.15</td>
#>       <td>3.44</td>
#>       <td>17.02</td>
#>       <td>0</td>
#>       <td>0</td>
#>       <td>3</td>
#>       <td>2</td>
#>     </tr>
#>     <tr>
#>       <th scope="row">Valiant</th>
#>       <td>18.1</td>
#>       <td>6</td>
#>       <td>225</td>
#>       <td>105</td>
#>       <td>2.76</td>
#>       <td>3.46</td>
#>       <td>20.22</td>
#>       <td>1</td>
#>       <td>0</td>
#>       <td>3</td>
#>       <td>1</td>
#>     </tr>
#>   </tbody>
#> </table>
```
