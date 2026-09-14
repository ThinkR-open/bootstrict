# Bootstrap navbar

A responsive navigation header. Compose with `bs_navbar_brand()`,
`bs_navbar_nav()` (containing
[`bs_nav_item()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md)
/
[`bs_nav_link()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md)
from the nav-tabs group), `bs_navbar_text()` and, for a menu,
[`bs_nav_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav_dropdown.md)
(not
[`bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md),
which builds the standalone button-triggered menu and is invalid inside
`<ul class="navbar-nav">`). The navbar collapses behind a toggler below
the `expand` breakpoint.

## Usage

``` r
bs_navbar(
  ...,
  brand = NULL,
  id = NULL,
  expand = "lg",
  bg = NULL,
  theme = NULL,
  placement = NULL,
  fluid = TRUE,
  class = NULL
)

bs_navbar_brand(..., href = "#", class = NULL)

bs_navbar_nav(
  ...,
  id = NULL,
  scroll = FALSE,
  scroll_height = NULL,
  class = NULL
)

bs_navbar_text(..., class = NULL)
```

## Arguments

- ...:

  Navbar content (brand, nav lists, text, ...) placed inside the
  collapsible container, plus named HTML attributes for the `<nav>`.

- brand:

  Optional brand element, typically `bs_navbar_brand()`, rendered before
  the toggler so it stays visible when collapsed.

- id:

  Optional id. When set, the active link's `value` is reported as
  `input$id` and can be set with
  [`update_bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_nav.md),
  exactly as for
  [`bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md).

- expand:

  Breakpoint at which the navbar expands: one of `"sm"`, `"md"`, `"lg"`,
  `"xl"`, `"xxl"`, or `TRUE` to always expand (`.navbar-expand`). Use
  `FALSE`/`NULL` to never expand (always collapsed).

- bg:

  Background colour (`.bg-*`): one of the Bootstrap theme colours, or
  `"body"`, `"body-secondary"`, `"body-tertiary"` (the Bootstrap 5.3
  navbar default), `"white"`, `"black"`, `"transparent"`.

- theme:

  Colour scheme applied via `data-bs-theme` (the Bootstrap 5.3
  colour-modes idiom; `.navbar-light`/`.navbar-dark` are deprecated):
  `"light"` or `"dark"`.

- placement:

  Fixed/sticky placement: one of `"fixed-top"`, `"fixed-bottom"`,
  `"sticky-top"`, `"sticky-bottom"`.

- fluid:

  If `TRUE` (default) use a full-width `.container-fluid`, otherwise a
  fixed-width `.container`.

- class:

  Extra classes for the `<nav>`.

- href:

  Link target for the brand.

- scroll:

  If `TRUE`, enable vertical scrolling within the collapsed navbar nav
  (`.navbar-nav-scroll`, Bootstrap 5.1).

- scroll_height:

  Max scroll height (sets `--bs-scroll-height`), e.g. `"75vh"` or
  `"200px"`. Only applies when `scroll = TRUE`.

## Value

A navbar tag.

## Examples

``` r
bs_navbar(brand = bs_navbar_brand("Navbar"), bg = "light", theme = "light")
#> <nav id="navbar-1" class="navbar navbar-expand-lg bg-light" data-bs-theme="light">
#>   <div class="container-fluid">
#>     <a class="navbar-brand" href="#">Navbar</a>
#>     <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbar-1-collapse" aria-controls="navbar-1-collapse" aria-expanded="false" aria-label="Toggle navigation">
#>       <span class="navbar-toggler-icon"></span>
#>     </button>
#>     <div class="collapse navbar-collapse" id="navbar-1-collapse"></div>
#>   </div>
#> </nav>
bs_navbar_brand("Acme", href = "/")
#> <a class="navbar-brand" href="/">Acme</a>
bs_navbar_nav(bs_nav_item(bs_nav_link("Home", active = TRUE)))
#> <ul class="navbar-nav">
#>   <li class="nav-item">
#>     <a class="nav-link active" href="#" aria-current="page" data-value="Home">Home</a>
#>   </li>
#> </ul>
bs_navbar_text("Signed in as Mark Otto")
#> <span class="navbar-text">Signed in as Mark Otto</span>
```
