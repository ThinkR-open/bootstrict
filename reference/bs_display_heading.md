# Bootstrap display heading

A larger, slightly more opinionated heading style (`.display-*`).

## Usage

``` r
bs_display_heading(..., level = 1, class = NULL)
```

## Arguments

- ...:

  Heading content and named HTML attributes.

- level:

  Display size / heading level (1-6).

- class:

  Extra classes.

## Value

A heading tag.

## Examples

``` r
bs_display_heading("Display heading", level = 2)
#> <h2 class="display-2">Display heading</h2>
```
