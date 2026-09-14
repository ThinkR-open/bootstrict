# Bootstrap grid column

Bootstrap grid column

## Usage

``` r
bs_col(
  ...,
  width = NULL,
  sm = NULL,
  md = NULL,
  lg = NULL,
  xl = NULL,
  xxl = NULL,
  offset = NULL,
  order = NULL,
  align_self = NULL,
  class = NULL
)
```

## Arguments

- ...:

  Content, and named HTML attributes.

- width:

  Base column span: an integer `1`-`12`, `"auto"`, or `TRUE` for an
  equal-width column. `NULL` (default) yields a bare `.col`.

- sm, md, lg, xl, xxl:

  Per-breakpoint spans (integer, `"auto"` or `TRUE`).

- offset:

  Column offset. A single value applies at the base breakpoint; a named
  list sets per-breakpoint offsets (e.g. `list(md = 2)`).

- order:

  Column order (`order-*`): integer `0`-`5`, `"first"` or `"last"`. A
  named list sets per-breakpoint order.

- align_self:

  Vertical self-alignment: `"start"`, `"center"`, `"end"`.

- class:

  Extra classes.

## Value

A column tag.

## Examples

``` r
bs_col(width = 6, md = 4, "content")
#> <div class="col-6 col-md-4">content</div>
```
