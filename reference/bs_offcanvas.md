# Bootstrap offcanvas

A hidden sidebar panel that slides in from an edge of the viewport. The
open/closed state is reported to the server as `input$id` (`TRUE` when
shown), and can be driven server-side with
[`show_bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_offcanvas.md),
[`hide_bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_offcanvas.md)
and
[`toggle_bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_offcanvas.md).
Open it declaratively from the UI with
[`bs_offcanvas_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas_trigger.md).

## Usage

``` r
bs_offcanvas(
  id,
  ...,
  title = NULL,
  placement = "start",
  backdrop = TRUE,
  scroll = FALSE,
  responsive = NULL,
  class = NULL
)
```

## Arguments

- id:

  Offcanvas id; open state available as `input$id`.

- ...:

  Offcanvas body content and named HTML attributes applied to the root.

- title:

  Optional header title. When supplied, an `.offcanvas-header` with a
  title and a close button is rendered.

- placement:

  Edge the panel slides in from: `"start"` (left), `"end"` (right),
  `"top"` or `"bottom"`.

- backdrop:

  Backdrop behaviour: `TRUE` (default, dismiss on outside click),
  `FALSE` (no backdrop) or `"static"` (backdrop that does not dismiss on
  outside click).

- scroll:

  If `TRUE`, allow body scrolling while the offcanvas is open.

- responsive:

  Optional breakpoint (`"sm"`, `"md"`, `"lg"`, `"xl"`, `"xxl"`). Below
  it the panel behaves as an offcanvas; at or above it the content is
  shown inline (Bootstrap 5.2 responsive offcanvas).

- class:

  Extra classes.

## Value

An offcanvas tag.

## Examples

``` r
bs_offcanvas("menu", "Sidebar content.", title = "Menu")
#> <div class="offcanvas offcanvas-start" tabindex="-1" id="menu" aria-labelledby="menu-title" data-bootstrict="offcanvas">
#>   <div class="offcanvas-header">
#>     <h5 class="offcanvas-title" id="menu-title">Menu</h5>
#>     <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="offcanvas" data-bs-target="#menu"></button>
#>   </div>
#>   <div class="offcanvas-body">Sidebar content.</div>
#> </div>
bs_offcanvas("nav", "Shown inline on lg+.", responsive = "lg")
#> <div class="offcanvas-lg offcanvas-start" tabindex="-1" id="nav" data-bootstrict="offcanvas">
#>   <div class="offcanvas-body">Shown inline on lg+.</div>
#> </div>
```
