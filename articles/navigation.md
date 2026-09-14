# Navigation

``` r

library(shiny)
library(bootstrict)
```

The navigation family: static navs, interactive tabsets, the navbar,
breadcrumbs, pagination and dropdowns.

## Nav vs. tabset

There are two related things here, and it is worth being clear about the
difference:

- **[`bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md)**
  is a *static* navigation bar — a styled row of links. It reports no
  state; you decide what each link does.
- **[`bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/bs_tabset.md)**
  is an *interactive* tabbed-panel set. It reports the active panel as
  `input$id` and is driven from the server with
  [`update_bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_tabset.md).
  This is the `bootstrict` equivalent of
  [`tabsetPanel()`](https://rdrr.io/pkg/shiny/man/tabsetPanel.html) /
  [`tabPanel()`](https://rdrr.io/pkg/shiny/man/tabPanel.html).

### Static nav

``` r

bs_nav(
  bs_nav_item(bs_nav_link("Active", active = TRUE)),
  bs_nav_item(bs_nav_link("Link", href = "#")),
  bs_nav_item(bs_nav_link("Disabled", disabled = TRUE)),
  type = "tabs"     # NULL (plain), "tabs", "pills" or "underline" (5.3)
)
```

`fill`, `justified` and `vertical` control how the links spread and
stack.

### Interactive tabset

Build a tabset from
[`bs_tab_panel()`](https://thinkr-open.github.io/bootstrict/reference/bs_tabset.md)s.
An `id` is required, and each panel’s `value` (defaulting to its title)
is what gets reported.

``` r

bs_tabset(
  "tabs",
  type = "tabs",          # "tabs" (default), "pills" or "underline"
  selected = "profile",
  bs_tab_panel("Home", "Home content", value = "home"),
  bs_tab_panel("Profile", "Profile content", value = "profile")
)
```

Read the active tab as `input$tabs`, and switch it from the server:

``` r

server <- function(input, output, session) {
  observe(print(input$tabs))                            # active panel value
  observeEvent(input$go, update_bs_tabset("tabs", selected = "home"))
}
```

The Bootstrap 5.3 `.nav-underline` style is available via
`type = "underline"` — used, for example, in the bundled Quake Watch
showcase.

## Navbar

[`bs_navbar()`](https://thinkr-open.github.io/bootstrict/reference/bs_navbar.md)
is a responsive header that collapses behind a toggler below the
`expand` breakpoint.

``` r

bs_navbar(
  ...,
  brand = NULL,       # usually a bs_navbar_brand()
  id = NULL,          # auto-generated if omitted
  expand = "lg",      # "sm"/"md"/"lg"/"xl"/"xxl", or TRUE (always) / FALSE (never)
  bg = NULL,          # a theme colour, or "body"/"body-secondary"/"white"/…
  theme = NULL,       # "light" or "dark" (data-bs-theme)
  placement = NULL,   # "fixed-top"/"fixed-bottom"/"sticky-top"/"sticky-bottom"
  fluid = TRUE,
  class = NULL
)
```

A typical navbar pairs a brand, a nav list and some text. Note the 5.3
idiom: for a dark navbar, set `theme = "dark"` (not the deprecated
`.navbar-dark`).

``` r

bs_navbar(
  brand = bs_navbar_brand("Quake Watch", href = "/"),
  bs_navbar_nav(
    bs_nav_item(bs_nav_link("Monitor", active = TRUE)),
    bs_nav_item(bs_nav_link("Docs", href = "#")),
    bs_nav_dropdown(
      "More",
      bs_dropdown_item("Settings", id = "settings"),
      bs_dropdown_divider(),
      bs_dropdown_item("Sign out", id = "signout")
    )
  ),
  bs_navbar_text("Fiji region · 1964 →"),
  bg = "primary",
  theme = "dark"
)
```

[`bs_navbar_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_navbar.md)
can scroll a long link list: `scroll = TRUE` with an optional
`scroll_height = "75vh"`.

## A navbar that switches pages

Bootstrap has no “navbar page” component: a navbar is a header, and
switching content is the application’s job. There is no
[`navbarPage()`](https://rdrr.io/pkg/shiny/man/navbarPage.html)
equivalent here on purpose, but the pattern is short. Give the navbar’s
links values with
[`bs_nav_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav_dropdown.md)
or drive a hidden tabset, and swap the content yourself.

``` r

ui <- bs_page(
  bs_navbar(
    brand = bs_navbar_brand("My app"),
    bs_navbar_nav(
      bs_nav_item(bs_nav_link("Monitor", active = TRUE, value = "monitor")),
      bs_nav_item(bs_nav_link("Docs", value = "docs")),
      id = "nav"
    )
  ),
  bs_container(uiOutput("page"))
)

server <- function(input, output, session) {
  output$page <- renderUI({
    switch(input$nav %||% "monitor",
      monitor = bs_card(bs_card_body("The monitor")),
      docs = bs_card(bs_card_body("The docs"))
    )
  })
}
```

`bs_navbar_nav(id =)` reports its active link the same way
`bs_nav(id =)` does, and
[`update_bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_nav.md)
sets it. Without an `id` the links stay inert, which is what a navbar of
plain anchors should be.

## Breadcrumbs

[`bs_breadcrumb()`](https://thinkr-open.github.io/bootstrict/reference/bs_breadcrumb.md)
composes
[`bs_breadcrumb_item()`](https://thinkr-open.github.io/bootstrict/reference/bs_breadcrumb.md)s;
the last item is usually `active = TRUE` (the current page, rendered
without a link).

``` r

bs_breadcrumb(
  bs_breadcrumb_item("Home", href = "#"),
  bs_breadcrumb_item("Library", href = "#"),
  bs_breadcrumb_item("Data", active = TRUE)
)
```

`divider=` sets the separator character via the
`--bs-breadcrumb-divider` CSS variable, e.g. `divider = ">"`.

## Pagination

Build pagination by hand from
[`bs_page_item()`](https://thinkr-open.github.io/bootstrict/reference/bs_page_item.md)s:

``` r

bs_pagination(
  bs_page_item("Previous", href = "#"),
  bs_page_item("1", href = "#", active = TRUE),
  bs_page_item("2", href = "#"),
  bs_page_item("Next", href = "#"),
  size = "sm",         # "sm" or "lg"
  align = "center"     # "start"/"center"/"end"
)
```

…or let
[`bs_pagination_numbered()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination_numbered.md)
lay out Previous / `1..n` / Next for you:

``` r

bs_pagination_numbered(5, current = 2, href_template = "?page=%d")
```

`href_template` is a
[`sprintf()`](https://rdrr.io/r/base/sprintf.html)-style pattern;
without it every link is `"#"`.

## Dropdowns

[`bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md)
builds a toggleable menu. To make a menu item reactive, give it an `id`
— it then behaves as a Shiny action button, reporting its click count as
`input$id`. Give the *dropdown* an `id` and its open state is reported
too, and
[`show_bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_dropdown.md)
/
[`hide_bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_dropdown.md)
/
[`toggle_bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_dropdown.md)
drive it from the server.

``` r

bs_dropdown(
  "Menu",
  bs_dropdown_header("Actions"),
  bs_dropdown_item("Edit", id = "edit"),
  bs_dropdown_item("Duplicate", id = "dup"),
  bs_dropdown_divider(),
  bs_dropdown_text("Signed in as Colin"),
  color = "secondary",   # a theme colour or "link"
  outline = TRUE
)
```

``` r

server <- function(input, output, session) {
  observeEvent(input$edit, message("Edit clicked"))
}
```

Other options: `size` (`"sm"`/`"lg"`), `split = TRUE` for a split
button, `direction` (`"down"`/`"up"`/`"end"`/`"start"`), `align`
(right-align the menu, or a responsive `list(lg = "end")`), and
`dark = TRUE` for a dark menu (the 5.3 `data-bs-theme` idiom).

Inside a nav or a navbar, use
[`bs_nav_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav_dropdown.md)
instead: Bootstrap’s menu there is an `<li class="nav-item dropdown">`
whose toggle is a `.nav-link`.
[`bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md)
would emit a `<div>` as a direct child of the `<ul class="navbar-nav">`
— invalid HTML that renders as a grey button. The menu items are the
same.

``` r

bs_nav_dropdown(
  "More",
  bs_dropdown_item("Settings", id = "settings"),
  bs_dropdown_divider(),
  bs_dropdown_item("Sign out", id = "signout"),
  align = "end"
)
```
