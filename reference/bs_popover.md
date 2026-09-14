# Add a Bootstrap popover to a UI element

Decorates an existing tag with the data attributes Bootstrap needs to
render a popover. Popovers are initialised client-side by bootstrict
(Bootstrap does not auto-initialise them). A tag that is already a
data-API trigger — a
[`bs_modal_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal_trigger.md),
[`bs_offcanvas_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas_trigger.md),
[`bs_collapse_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse_trigger.md)
or a dropdown toggle — keeps its own `data-bs-toggle`; the popover works
alongside it.

## Usage

``` r
bs_popover(
  tag,
  content,
  ...,
  title = NULL,
  placement = "right",
  trigger = "click",
  html = FALSE
)
```

## Arguments

- tag:

  A UI element (a `shiny.tag`) to attach the popover to.

- content:

  Popover body content (or HTML, when `html = TRUE`).

- ...:

  Extra named attributes applied to `tag`.

- title:

  Optional popover header.

- placement:

  Popover placement: `"auto"`, `"top"`, `"right"`, `"bottom"` or
  `"left"`.

- trigger:

  How the popover is triggered (e.g. `"click"`, `"hover"`, `"focus"`,
  `"manual"`).

- html:

  If `TRUE`, allow HTML content in the popover (`data-bs-html`).

## Value

The decorated tag, with the bootstrict dependency attached.

## Examples

``` r
bs_popover(shiny::tags$button("Click me"), "Popover body", title = "Heads up")
#> <button data-bs-toggle="popover" data-bs-content="Popover body" data-bs-title="Heads up" data-bs-placement="right" data-bs-trigger="click" data-bootstrict-tip="popover">Click me</button>
```
