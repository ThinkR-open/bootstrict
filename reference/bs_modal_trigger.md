# Trigger a modal from the UI

Renders a button that opens the modal whose id matches `target`, using
Bootstrap's declarative `data-bs-toggle="modal"` attributes (no server
round trip required).

## Usage

``` r
bs_modal_trigger(target, ..., class = NULL)
```

## Arguments

- target:

  Id of the
  [`bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
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
bs_modal_trigger("info", "Open modal", color = "primary")
#> <button class="btn btn-primary" type="button" data-bs-toggle="modal" data-bs-target="#info">Open modal</button>
```
