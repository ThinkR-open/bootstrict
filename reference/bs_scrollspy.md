# Bootstrap scrollspy container

Wraps content in a scrollable region whose nav (identified by `target`)
is updated as the user scrolls.

## Usage

``` r
bs_scrollspy(
  target,
  ...,
  id = NULL,
  offset = NULL,
  root_margin = NULL,
  threshold = NULL,
  smooth = TRUE,
  class = NULL
)
```

## Arguments

- target:

  Id (without `#`) of the nav / list-group that scrollspy drives.

- ...:

  Scrollable content and named HTML attributes.

- id:

  Optional container id. The href of the currently active nav link is
  reported as `input$id`. Defaults to a unique auto-generated id (an id
  is required for bootstrict to initialise scrollspy, including inside
  [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) —
  Bootstrap only auto-initialises on full page load).

- offset:

  Pixels from the top to offset link activation (`data-bs-offset`).
  Deprecated in Bootstrap 5.3, which drives scrollspy with an
  `IntersectionObserver`: use `root_margin` instead.

- root_margin:

  The observer's root margin (`data-bs-root-margin`), Bootstrap's
  replacement for `offset`. Defaults to `"0px 0px -25%"`.

- threshold:

  Visibility ratios at which a section becomes active
  (`data-bs-threshold`), e.g. `c(0, 0.5, 1)`.

- smooth:

  If `TRUE`, enable smooth scrolling (`data-bs-smooth-scroll`).

- class:

  Extra classes.

## Value

A scrollspy container tag, with the bootstrict dependency attached.

## Examples

``` r
bs_scrollspy("nav-menu", shiny::tags$h4("Section"), offset = 100)
#> <div id="bs-scrollspy-1" data-bs-spy="scroll" data-bs-target="#nav-menu" data-bs-offset="100" data-bs-smooth-scroll="true" tabindex="0" data-bootstrict="scrollspy">
#>   <h4>Section</h4>
#> </div>
```
