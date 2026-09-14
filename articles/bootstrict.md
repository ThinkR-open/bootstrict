# Get started with bootstrict

`bootstrict` re-implements the **Bootstrap 5.3** layout, content, forms
and component library as Shiny UI functions. Every widget mirrors the
Bootstrap 5.3 HTML structure **one-to-one**, so a designer’s mockup and
exported SASS variables drop straight into a Shiny application — with
**minimum deviation from Shiny itself**.

``` r

library(shiny)
library(bootstrict)
```

## Why bootstrict

Working with a designer who does not know Shiny is awkward for two
reasons:

- some Shiny components are *not* plain Bootstrap; and
- some Bootstrap components are *missing* from Shiny.

`bootstrict` closes that gap by giving you the whole Bootstrap 5
surface, and **nothing more** — so you can tell a designer: *“use
anything from [the Bootstrap 5.3
docs](https://getbootstrap.com/docs/5.3/), but nothing else.”* The
Bootstrap 5.3 runtime and SASS compilation come from
[`bslib`](https://rstudio.github.io/bslib/); there is nothing else to
vendor.

## A first app

Every app starts with a page constructor
([`bs_page()`](https://thinkr-open.github.io/bootstrict/reference/bs_page.md)),
a theme, and Bootstrap widgets composed like any other Shiny UI:

``` r

ui <- bs_page(
  title = "Sign in",
  theme = bootstrict_theme(primary = "#ff6600"),
  bs_container(
    bs_card(
      bs_card_header("Sign in"),
      bs_card_body(
        bs_text_input("email", "Email", placeholder = "you@example.com"),
        bs_password_input("pw", "Password"),
        bs_button("go", "Sign in", color = "primary")
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$go, {
    print(input$email)
    print(input$pw)
  })
}

shinyApp(ui, server)
```

## Conventions (minimum deviation from Shiny)

Once you know these four rules you know how *every* constructor in the
package behaves:

- **Naming.** Every constructor is `snake_case`, prefixed `bs_`
  ([`bs_card()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md),
  [`bs_text_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_text_input.md),
  …). Nothing masks a Shiny function.
- **`...` works exactly like Shiny/htmltools.** **Named** arguments
  become HTML attributes; **unnamed** arguments become children. Extra
  `class` values passed through `...` are merged with the component’s
  own classes.
- **Interactive widgets take a leading `id`.** Their value is then
  available as `input$id`, just like a Shiny input.
- **Form inputs delegate to the matching `shiny::*Input()`.** So the
  reactive value and every `updateXxx()` keep working identically —
  `bootstrict` only layers Bootstrap 5 markup, sizing, help text,
  switches, input groups and floating labels on top.

## The map of the package

`bootstrict` covers the whole Bootstrap 5.3 catalogue. Each area has its
own article:

| Article | What it covers |
|----|----|
| [Theming and the designer hand-off](https://thinkr-open.github.io/bootstrict/articles/theming.md) | [`bootstrict_theme()`](https://thinkr-open.github.io/bootstrict/reference/bootstrict_theme.md), SASS variable sheets, colour modes |
| [Layout and the grid](https://thinkr-open.github.io/bootstrict/articles/layout.md) | pages, containers, the 12-column grid, stacks |
| [Content: tables, media and typography](https://thinkr-open.github.io/bootstrict/articles/content.md) | [`bs_table()`](https://thinkr-open.github.io/bootstrict/reference/bs_table.md), images, figures, blockquotes, headings, lists |
| [Forms and inputs](https://thinkr-open.github.io/bootstrict/articles/forms.md) | every input, input groups, floating labels, validation |
| [Components](https://thinkr-open.github.io/bootstrict/articles/components.md) | accordion, alert, badge, buttons, card, carousel, collapse, list group, progress, spinner, placeholder |
| [Navigation](https://thinkr-open.github.io/bootstrict/articles/navigation.md) | nav & tabs, navbar, breadcrumb, pagination, dropdown |
| [Overlays and server-driven interactivity](https://thinkr-open.github.io/bootstrict/articles/overlays.md) | modal, offcanvas, toast, tooltips/popovers, the `update_bs_*()` pattern |

## How bootstrict differs from Shiny

`bootstrict` stays as close to Shiny as it can, but a handful of
behaviours differ **on purpose**, to follow native Bootstrap. If you
already know Shiny, these are the things to watch for — each is covered
in depth in the article listed.

### Overlays live in the UI — they are not built from the server

Shiny builds modals and notifications on the server
(`showModal(modalDialog(...))`). `bootstrict` follows the native
Bootstrap pattern: the modal, toast or offcanvas is declared **once in
the UI** with an `id`, and the server only **opens or closes it by id**.

| Task | Shiny | bootstrict |
|----|----|----|
| Open a modal | `showModal(modalDialog(...))` | declare `bs_modal("id", …)`, then `show_bs_modal("id")` |
| Close a modal | [`removeModal()`](https://rdrr.io/pkg/shiny/man/showModal.html) | `hide_bs_modal("id")` |
| Notification | `showNotification("…")` | `bs_notify_toast("…")` |
| Offcanvas / drawer | *(not in Shiny)* | declare `bs_offcanvas("id", …)`, then `show_bs_offcanvas("id")` |

Place overlay widgets at the **top level of the page** (a direct child
of
[`bs_page()`](https://thinkr-open.github.io/bootstrict/reference/bs_page.md)
/
[`bs_container()`](https://thinkr-open.github.io/bootstrict/reference/bs_container.md)),
never nested inside a
[`bs_card()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
— Bootstrap can otherwise clip or mis-position them. See
[Overlays](https://thinkr-open.github.io/bootstrict/articles/overlays.md).

### Server helpers take `id` first and `session` last

Shiny’s updaters take the session first:
`updateTextInput(session, "id", …)`. Every `bootstrict` helper takes the
**id first** and the **session last and optional** (it defaults to the
current reactive domain), and ids are namespaced automatically inside
modules:

``` r

update_bs_tabset("tabs", selected = "profile") # no session argument needed
show_bs_modal("info")
```

### Two kinds of inputs

1.  **Inputs that delegate to Shiny** —
    [`bs_text_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_text_input.md),
    [`bs_numeric_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_numeric_input.md),
    [`bs_select_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_select_input.md),
    [`bs_radio_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_input.md),
    [`bs_checkbox_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_checkbox_input.md),
    [`bs_checkbox_group_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_checkbox_group_input.md),
    [`bs_file_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_file_input.md),
    [`bs_textarea_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_textarea_input.md),
    [`bs_password_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_password_input.md).
    They wrap the matching `shiny::*Input()`, so `input$id` **and
    Shiny’s own `updateXxx()` keep working unchanged**.
2.  **Native inputs** —
    [`bs_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_range_input.md),
    [`bs_color_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_color_input.md),
    [`bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_input.md),
    [`bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_range_input.md)
    and the `.btn-check` segmented controls
    ([`bs_radio_button_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_button_input.md),
    [`bs_checkbox_button_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_button_input.md)).
    Either Shiny has no equivalent, or its equivalent is not Bootstrap
    markup. They ship their own bindings, so drive them with
    [`update_bs_range()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_range.md)
    /
    [`update_bs_color()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_color.md)
    /
    [`update_bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_date_input.md)
    /
    [`update_bs_toggle_buttons()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_toggle_buttons.md).

### `bs_button()` is an action button only when given an id

`bs_button("go", "Go")` behaves exactly like
[`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
— `input$go` is the click count. Called **without** an `id` it is an
inert, styled button; reactivity is opt-in.

## Run the bundled apps

``` r

# The catalogue: every widget, one card each.
shiny::runApp(system.file("examples/demo", package = "bootstrict"))

# The showcase: Quake Watch, a seismic monitor built on datasets::quakes.
shiny::runApp(system.file("examples/quakewatch", package = "bootstrict"))
```
