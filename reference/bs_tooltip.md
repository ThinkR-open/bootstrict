# Add a Bootstrap tooltip to a UI element

Decorates an existing tag with the data attributes Bootstrap needs to
render a tooltip. Tooltips are initialised client-side by bootstrict
(Bootstrap does not auto-initialise them). A tag that is already a
data-API trigger — a
[`bs_modal_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal_trigger.md),
[`bs_offcanvas_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas_trigger.md),
[`bs_collapse_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse_trigger.md)
or a dropdown toggle — keeps its own `data-bs-toggle`; the tooltip works
alongside it.

## Usage

``` r
bs_tooltip(tag, title, ..., placement = "top", html = FALSE, trigger = NULL)
```

## Arguments

- tag:

  A UI element (a `shiny.tag`) to attach the tooltip to.

- title:

  Tooltip text (or HTML, when `html = TRUE`).

- ...:

  Extra named attributes applied to `tag`.

- placement:

  Tooltip placement: `"auto"`, `"top"`, `"right"`, `"bottom"` or
  `"left"`.

- html:

  If `TRUE`, allow HTML content in the tooltip (`data-bs-html`).

- trigger:

  How the tooltip is triggered (e.g. `"hover focus"`, `"click"`,
  `"manual"`); `NULL` uses the Bootstrap default.

## Value

The decorated tag, with the bootstrict dependency attached.

## Examples

``` r
bs_tooltip(shiny::tags$button("Hover me"), "Tooltip text")
#> <button data-bs-toggle="tooltip" data-bs-title="Tooltip text" data-bs-placement="top" data-bootstrict-tip="tooltip">Hover me</button>
```
