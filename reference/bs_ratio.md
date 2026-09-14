# Fixed aspect-ratio container

Wraps an embedded element (image, iframe, video, ...) so it keeps a
fixed aspect ratio (`.ratio`).

## Usage

``` r
bs_ratio(..., ratio = "16x9", class = NULL)
```

## Arguments

- ...:

  The embedded element and named HTML attributes.

- ratio:

  Aspect ratio: one of `"1x1"`, `"4x3"`, `"16x9"`, `"21x9"`.

- class:

  Extra classes.

## Value

A `<div>` tag.

## Examples

``` r
bs_ratio(shiny::tags$iframe(src = "https://example.com"), ratio = "16x9")
#> <div class="ratio ratio-16x9">
#>   <iframe src="https://example.com"></iframe>
#> </div>
```
