# Trigger an offcanvas from the UI

Renders a button that opens the offcanvas whose id matches `target`,
using Bootstrap's declarative `data-bs-toggle="offcanvas"` attributes
(no server round trip required).

## Usage

``` r
bs_offcanvas_trigger(target, ..., class = NULL)
```

## Arguments

- target:

  Id of the
  [`bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas.md)
  to open.

- ...:

  Content (label) and named HTML attributes, forwarded to
  [`bs_button()`](https://thinkr-open.github.io/bootstrict/reference/bs_button.md).

- class:

  Extra classes.

## Value

A button tag.

## Examples

``` r
bs_offcanvas_trigger("menu", "Open menu")
#> <button class="btn btn-primary" type="button" data-bs-toggle="offcanvas" data-bs-target="#menu" aria-controls="menu">Open menu</button>
```
