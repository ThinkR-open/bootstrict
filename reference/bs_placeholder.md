# Bootstrap placeholder

Loading placeholders ("skeletons") that mimic the shape of content while
it loads. Use `bs_placeholder()` for an individual placeholder and wrap
one or more in `bs_placeholder_glow()` or `bs_placeholder_wave()` to
animate them.

## Usage

``` r
bs_placeholder(..., width = NULL, color = NULL, size = NULL, class = NULL)

bs_placeholder_glow(..., class = NULL)

bs_placeholder_wave(..., class = NULL)
```

## Arguments

- ...:

  Additional named HTML attributes (and, for the wrappers, child
  content) applied to the element.

- width:

  Column count (integer 1-12) controlling the placeholder width via the
  grid (`.col-*`).

- color:

  Background theme colour (`.bg-*`), one of the Bootstrap theme colours.

- size:

  Placeholder size, one of `"lg"`, `"sm"` or `"xs"`; `NULL` for the
  default size.

- class:

  Extra classes.

## Value

A placeholder tag.

## Examples

``` r
bs_placeholder_glow(bs_placeholder(width = 6))
#> <p class="placeholder-glow">
#>   <span class="placeholder col-6"></span>
#> </p>
bs_placeholder_wave(bs_placeholder(width = 4))
#> <p class="placeholder-wave">
#>   <span class="placeholder col-4"></span>
#> </p>
```
