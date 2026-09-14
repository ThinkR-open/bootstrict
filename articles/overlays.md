# Overlays and server-driven interactivity

``` r

library(shiny)
library(bootstrict)
```

This article covers the overlay widgets — modal, offcanvas, toast — plus
tooltips, popovers and scrollspy, and pulls together the one pattern
that runs through the whole package: interactive widgets report their
state as `input$id` and are controlled from the server with `id`-first
helpers.

## The overlay model: declare in the UI, open by id

This is the biggest deliberate difference from Shiny. Shiny builds
overlays on the server (`showModal(modalDialog(...))`). `bootstrict`
follows the native Bootstrap pattern: **declare the overlay once in the
UI with an `id`, then open or close it by id from the server.**

Two consequences follow:

- **Place overlays at the top level of the page** — a direct child of
  [`bs_page()`](https://thinkr-open.github.io/bootstrict/reference/bs_page.md)
  /
  [`bs_container()`](https://thinkr-open.github.io/bootstrict/reference/bs_container.md),
  *not* nested inside a
  [`bs_card()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
  or other positioned element, which Bootstrap can clip or mis-position.
- **Every overlay reports its open state as `input$id`** (`TRUE` when
  shown) — something Shiny modals do not do.

## Modal

Declare a
[`bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
with an `id`; open it with
[`show_bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_modal.md).

``` r

ui <- bs_page(
  bs_container(
    bs_button("open", "Open modal", color = "primary")
  ),
  # top level of the page, not inside the container's card
  bs_modal(
    "info",
    "Modal body text.",
    title = "Heads up",
    footer = bs_button("ok", "OK", color = "primary")
  )
)

server <- function(input, output, session) {
  observeEvent(input$open, show_bs_modal("info"))
  observeEvent(input$info, message("modal open state: ", input$info))
}

shinyApp(ui, server)
```

The server helpers are
[`show_bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_modal.md),
[`hide_bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_modal.md)
and
[`toggle_bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_modal.md)
— each `id`-first, session-last:

``` r

show_bs_modal("info")
hide_bs_modal("info")
```

Options: `size` (`"sm"`/`"lg"`/`"xl"`), `centered`, `scrollable`,
`fullscreen` (`TRUE`, or a breakpoint for fullscreen-below), `backdrop`
(`TRUE` / `"static"` / `FALSE`) and `keyboard` (Escape to close). The
pieces
[`bs_modal_header()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md),
[`bs_modal_title()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md),
[`bs_modal_body()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
and
[`bs_modal_footer()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
are there when you want to hand-build the dialog.

### Dynamic content

An overlay is declared once, but its content need not be fixed: put a
[`uiOutput()`](https://rdrr.io/pkg/shiny/man/htmlOutput.html) in the
body and render into it. This is how you show a record the user just
picked, without rebuilding the modal.

``` r

ui <- bs_page(
  bs_container(
    bs_button("show", "Show details"),
    bs_modal("details", uiOutput("details_body"), title = "Details")
  )
)

server <- function(input, output, session) {
  output$details_body <- renderUI({
    bs_table(head(mtcars, input$show %% 5 + 1))
  })
  observeEvent(input$show, show_bs_modal("details"))
}
```

Re-rendering while the overlay is open is safe: the widget is torn down
after its hide transition, so the page is never left scroll-locked.

### Opening without a server round trip

[`bs_modal_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal_trigger.md)
opens a modal declaratively from the UI — no `observeEvent` needed:

``` r

bs_modal_trigger("info", "Open modal", color = "primary")
```

## Offcanvas (drawer)

An offcanvas is a panel that slides in from an edge — Shiny has no
equivalent. Same model as the modal: declare it, open it by id.

``` r

ui <- bs_page(
  bs_container(
    bs_offcanvas_trigger("filters", "Filters", class = "btn-primary")
  ),
  bs_offcanvas(
    "filters",
    title = "Filter events",
    placement = "end",              # "start"/"end"/"top"/"bottom"
    bs_range_input("mag", "Minimum magnitude", value = 4, min = 4, max = 6.5),
    bs_button("reset", "Reset", color = "secondary", outline = TRUE)
  )
)

server <- function(input, output, session) {
  observeEvent(input$reset, {
    update_bs_range("mag", 4)
    hide_bs_offcanvas("filters")
  })
}

shinyApp(ui, server)
```

Server helpers:
[`show_bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_offcanvas.md),
[`hide_bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_offcanvas.md),
[`toggle_bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_offcanvas.md),
plus the UI
[`bs_offcanvas_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas_trigger.md).
`backdrop` behaves as for the modal; `responsive = "lg"` shows the panel
inline from that breakpoint up and only turns it into a drawer below it.

## Toasts

A toast is a small, transient notification. There are two ways to use
them.

**Declared toast.** Declare a
[`bs_toast()`](https://thinkr-open.github.io/bootstrict/reference/bs_toast.md)
(usually inside a
[`bs_toast_container()`](https://thinkr-open.github.io/bootstrict/reference/bs_toast_container.md)
that positions it) and show it by id:

``` r

ui <- bs_page(
  bs_button("save", "Save"),
  bs_toast_container(
    bs_toast("saved", "Your changes were saved.", title = "Done"),
    placement = "top-end"
  )
)

server <- function(input, output, session) {
  observeEvent(input$save, show_bs_toast("saved"))
}
```

**Notification toast.**
[`bs_notify_toast()`](https://thinkr-open.github.io/bootstrict/reference/bs_notify_toast.md)
is the one server-built widget — the closest thing to
[`shiny::showNotification()`](https://rdrr.io/pkg/shiny/man/showNotification.html).
It builds *and* shows a transient toast in one call, creating a
container on demand and cleaning itself up afterwards. Note the argument
order: `body` first, `session` last.

``` r

bs_notify_toast(
  "Showing the full catalogue again.",
  title = "Filters reset",
  color = "success"
)
```

`body` and `title` are plain text only. `color` is a theme colour
(`.text-bg-*`), `autohide`/`delay` control the auto-dismiss, and
`placement` uses the same nine keywords as
[`bs_toast_container()`](https://thinkr-open.github.io/bootstrict/reference/bs_toast_container.md)
(`"top-end"`, `"bottom-center"`, …).

## Tooltips and popovers

These **decorate a tag you already have** — they are pipe-friendly
wrappers, not constructors. Bootstrap does not auto-initialise them, but
`bootstrict` does. They are UI-only: there is no server-side toggle.

``` r

bs_tooltip(bs_button(label = "Hover me"), "Tooltip text", placement = "top")

bs_popover(
  bs_button(label = "Click me"),
  "Popover body content",
  title = "Heads up",
  placement = "right"
)
```

[`bs_tooltip()`](https://thinkr-open.github.io/bootstrict/reference/bs_tooltip.md)
takes `title`;
[`bs_popover()`](https://thinkr-open.github.io/bootstrict/reference/bs_popover.md)
takes `content` (and an optional `title`). Both accept `placement`
(`"top"`/`"right"`/`"bottom"`/`"left"`), `trigger` and `html = TRUE` to
allow HTML content.

## Scrollspy

[`bs_scrollspy()`](https://thinkr-open.github.io/bootstrict/reference/bs_scrollspy.md)
wraps a scrollable region and updates a nav (identified by `target`) as
the user scrolls. It needs an `id` to initialise (one is auto-generated
if you omit it), including inside
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html); the active
nav link’s href is reported as `input$id`.

``` r

bs_scrollspy(
  "section-nav",
  tags$h4("Section one"), tags$p("..."),
  tags$h4("Section two"), tags$p("..."),
  offset = 100
)
```

## Inside a Shiny module

The two halves are not symmetric, and it is the one place bootstrict
asks you to think.

**Server helpers namespace for you.** `show_bs_modal("info")` inside a
[`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html)
resolves to the module’s `info`, because the helper reads the session’s
namespace. Never wrap them in `ns()`.

**UI triggers do not.**
[`bs_modal_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal_trigger.md),
[`bs_offcanvas_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas_trigger.md)
and
[`bs_collapse_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse_trigger.md)
take the id of a *target element*, which is a plain string at UI build
time with no session to consult. Wrap those in `ns()` yourself, exactly
as you would a `tabPanel` id.

``` r

panel_ui <- function(id) {
  ns <- NS(id)
  bs_container(
    # The widget's own id: namespaced, like any input.
    bs_modal(ns("info"), "Body", title = "Heads up"),
    # A trigger points at that element, so it needs the same treatment.
    bs_modal_trigger(ns("info"), "Open"),
    bs_button(ns("open"), "Open from the server")
  )
}

panel_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # No ns() here: the helper takes it from the session.
    observeEvent(input$open, show_bs_modal("info"))
  })
}
```

The same rule covers
[`bs_collapse_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse_trigger.md)
pointing at a
[`bs_collapse()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse.md),
and `bs_scrollspy(target =)` pointing at a nav.

## The pattern, in one place

Every interactive widget in `bootstrict` follows the same two-way
contract:

| Widget | Reads back as `input$id` | Server control |
|----|----|----|
| [`bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/bs_tabset.md) | active panel value | [`update_bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_tabset.md) |
| [`bs_accordion()`](https://thinkr-open.github.io/bootstrict/reference/bs_accordion.md) | open panel value(s) | [`update_bs_accordion()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_accordion.md) |
| [`bs_carousel()`](https://thinkr-open.github.io/bootstrict/reference/bs_carousel.md) | active slide index (0-based) | [`update_bs_carousel()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_carousel.md) |
| [`bs_collapse()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse.md) | shown/hidden (`TRUE`/`FALSE`) | [`update_bs_collapse()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_collapse.md) |
| `bs_list_group(id=)` | selected item value | [`update_bs_list_group()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_list_group.md) |
| `bs_progress_bar(id=)` | *(display only)* | [`update_bs_progress()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_progress.md) |
| [`bs_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_range_input.md) | value | [`update_bs_range()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_range.md) |
| [`bs_color_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_color_input.md) | value | [`update_bs_color()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_color.md) |
| [`bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md) | open (`TRUE`/`FALSE`) | `show_/hide_/toggle_bs_modal()` |
| [`bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas.md) | open (`TRUE`/`FALSE`) | `show_/hide_/toggle_bs_offcanvas()` |
| [`bs_toast()`](https://thinkr-open.github.io/bootstrict/reference/bs_toast.md) | visible (`TRUE`/`FALSE`) | `show_/hide_bs_toast()` |
| page colour mode | — | [`set_bs_color_mode()`](https://thinkr-open.github.io/bootstrict/reference/set_bs_color_mode.md) |

Every one of these helpers takes the **`id` first** and the **`session`
last and optional** (it defaults to the current reactive domain), and
ids are namespaced automatically inside Shiny modules — so the same call
works at the top level and inside a module with no changes:

``` r

update_bs_tabset("tabs", selected = "profile")   # no session argument needed
show_bs_modal("info")
set_bs_color_mode("dark")
```
