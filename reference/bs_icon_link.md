# Bootstrap icon link

The Bootstrap 5.3 icon-link helper: an inline flex `<a>` that pairs an
icon (e.g. an SVG) with text, with an optional hover translation of the
icon (`.icon-link-hover`).

## Usage

``` r
bs_icon_link(..., href = "#", hover = FALSE, class = NULL)
```

## Arguments

- ...:

  Link content (icon and text) and named HTML attributes.

- href:

  Link target.

- hover:

  If `TRUE`, translate the icon on hover (`.icon-link-hover`).

- class:

  Extra classes.

## Value

An anchor tag.

## Examples

``` r
bs_icon_link("Icon link", href = "#")
#> <a class="icon-link" href="#">Icon link</a>
```
