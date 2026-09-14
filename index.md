# bootstrict

> Strict, faithful Bootstrap 5.3 widgets for Shiny — with minimum
> deviation from Shiny itself.

`bootstrict` re-implements the **Bootstrap 5.3** layout, content, forms
and component library as Shiny UI functions.

## Why

Working with an external designer that doesn’t know
[shiny](https://shiny.posit.co/) can be complex because of two things:

- some Shiny components are *not* plain Bootstrap;
- some Bootstrap components are *missing* from Shiny.

`bootstrict` tries to fix this gap by giving you the whole Bootstrap 5
surface, and **nothing more**, meaning that you can tell a designer:
“you can use anything from Bootstrap 5.3. But nothing more”.

## Installation

``` r

# install.packages("pak")
pak::pak("thinkr-open/bootstrict")
```

The Bootstrap 5.3 runtime and SASS compilation are provided by
[`bslib`](https://rstudio.github.io/bslib/) — there is nothing else to
vendor, and the markup bootstrict emits matches the runtime it runs on.

## The designer hand-off

Every widget mirrors the Bootstrap 5.3 HTML structure **one-to-one**, so
a designer’s mockup (for example in Figma) and exported SASS variables
drop straight into a Shiny app. Interactive components report their
state to the server and can be driven from the server with `update_*()`
helpers.

One thing falls short of that, inherited from the Shiny inputs the
package delegates to: every delegated input keeps Shiny’s
`div.form-group.shiny-input-container` wrapper. Everything else is the
reference markup, and the test suite snapshots it — no third-party
widget library is shipped, and a test enforces that.

The rule, when the two collide: if it is not in the Bootstrap
documentation it is not in `bootstrict`, even where that loses a Shiny
feature.

The motivating workflow: a designer works in Figma, stays strictly
within [the Bootstrap 5.3 docs](https://getbootstrap.com/docs/5.3/), and
exports a `_variables.scss` sheet.

You received a Figma mockup and the variables, and can implement this
directly into shiny.

``` r

library(shiny)
library(bootstrict)


variables <- tempfile(fileext = ".scss")
writeLines(
  c(
    "$primary: #ff6600;",
    "$border-radius:5rem;"
  ),
  variables
)

ui <- bs_page(
  theme = bootstrict_theme(
    variables = variables
  ),
  bs_container(
    bs_card(
      bs_card_header("Sign in"),
      bs_card_body(
        bs_text_input("email", "Email", placeholder = "you@example.com"),
        bs_password_input("pw", "Password"),
        bs_button("go", "Sign in", color = "primary")
      )
    ),
    # Declare the modal once, at the top level of the page (not inside the
    # card): Bootstrap can clip or mis-position overlays nested in another
    # element. The server then opens it by id (see below).
    bs_modal(
      "info",
      "Modal body text.",
      title = "Heads up"
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$go, {
    print(input$email)
    print(input$pw)
    show_bs_modal("info")
   })
}

shinyApp(ui, server)
```

[`bootstrict_theme()`](https://thinkr-open.github.io/bootstrict/reference/bootstrict_theme.md)
is a thin wrapper over
[`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
pinned to Bootstrap 5;
[`parse_scss_variables()`](https://thinkr-open.github.io/bootstrict/reference/parse_scss_variables.md)
turns a `$name: value;` sheet into the named list `bslib` expects.
Inline overrides win over the file:

``` r

bootstrict_theme(
  variables = "_variables.scss",
  primary = "#ff6600"
)
```

## Conventions (minimum deviation from Shiny)

- Every constructor is `snake_case`, prefixed `bs_` (no masking of
  Shiny).
- `...` works exactly like Shiny/htmltools: **named** args become HTML
  attributes, **unnamed** args become children.
- Interactive widgets take a leading `id`; their value is `input$id`.
- **Form inputs delegate to the matching `shiny::*Input()`**, so the
  reactive value and every `updateXxx()` keep working identically —
  `bootstrict` only layers Bootstrap 5 markup, sizing, help text,
  switches, input groups and floating labels on top.

## How bootstrict differs from Shiny

`bootstrict` stays as close to Shiny as it can, but a handful of
behaviours differ **on purpose** (to follow native Bootstrap). If you
already know Shiny, these are the things to watch for.

### Overlay widgets live in the UI — they aren’t built from the server

Shiny builds modals and notifications on the server
(`showModal(modalDialog(...))`, `showNotification(...)`). `bootstrict`
follows the native Bootstrap pattern instead: the modal, toast or
offcanvas is declared **once in the UI** with an `id`, and the server
only **opens or closes it by id**.

``` r

ui <- bs_page(
  bs_button(
    "open",
    "Open"
  ),
  # declared in the UI
  bs_modal(
    "info",
    "Body text",
    title = "Heads up"
  )
)
server <- function(input, output, session) {
  observeEvent(
    input$open, {
      # opened by id
      show_bs_modal("info")
    }
   )
}
```

| Task | Shiny | bootstrict |
|----|----|----|
| Open a modal | `showModal(modalDialog(...))` | declare `bs_modal("id", …)`, then `show_bs_modal("id")` |
| Close a modal | [`removeModal()`](https://rdrr.io/pkg/shiny/man/showModal.html) | `hide_bs_modal("id")` |
| Notification | `showNotification("…")` | `bs_notify_toast("…")` — the one server-built widget (builds + shows a transient toast) |
| Offcanvas / drawer | *(not in Shiny)* | declare `bs_offcanvas("id", …)`, then `show_bs_offcanvas("id")` |

Two consequences:

- **Place overlay widgets at the top level of the page** (a direct child
  of
  [`bs_page()`](https://thinkr-open.github.io/bootstrict/reference/bs_page.md)
  /
  [`bs_container()`](https://thinkr-open.github.io/bootstrict/reference/bs_container.md)),
  *not* nested inside a
  [`bs_card()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
  or other positioned element — Bootstrap can otherwise clip or
  mis-position them.
- Every overlay reports its **open state** back as `input$id` (`TRUE`
  when shown) — Shiny modals don’t. You can also open them with **no
  server round trip** using the UI triggers
  [`bs_modal_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal_trigger.md),
  [`bs_offcanvas_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas_trigger.md)
  and
  [`bs_collapse_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse_trigger.md).

### Server helpers take `id` first and `session` last

Shiny’s updaters take the session first:
`updateTextInput(session, "id", …)`. Every `bootstrict` helper takes the
**id first** and the **session last and optional** (it defaults to the
current reactive domain), and ids are namespaced automatically inside
modules:

``` r

update_bs_tabset("tabs", selected = "profile")   # no session argument needed
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
    They wrap the matching `shiny::*Input()` and only restyle the
    markup, so `input$id` **and Shiny’s own `updateXxx()` keep working
    unchanged** — use
    [`shiny::updateTextInput()`](https://rdrr.io/pkg/shiny/man/updateTextInput.html)
    etc. for these.
2.  **Native inputs** —
    [`bs_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_range_input.md),
    [`bs_color_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_color_input.md),
    [`bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_input.md),
    [`bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_range_input.md),
    [`bs_radio_button_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_button_input.md)
    and
    [`bs_checkbox_button_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_button_input.md).
    Either Shiny has no equivalent, or its equivalent is not Bootstrap
    markup. They ship their own bindings, so drive them with
    [`update_bs_range()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_range.md)
    /
    [`update_bs_color()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_color.md)
    /
    [`update_bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_date_input.md)
    /
    [`update_bs_toggle_buttons()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_toggle_buttons.md)
    (Shiny’s
    [`updateSliderInput()`](https://rdrr.io/pkg/shiny/man/updateSliderInput.html)
    and
    [`updateDateInput()`](https://rdrr.io/pkg/shiny/man/updateDateInput.html)
    won’t reach them).

A few specifics worth knowing:

- [`bs_select_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_select_input.md)
  renders a **plain Bootstrap `<select>`** — selectize is off, so there
  is no search / tagging box that Shiny’s
  [`selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html) adds
  by default.
- [`bs_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_range_input.md)
  is a native HTML `<input type="range">`, **not** Shiny’s
  [`sliderInput()`](https://rdrr.io/pkg/shiny/man/sliderInput.html) (no
  ticks, animation or ion.rangeSlider features).
- [`bs_file_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_file_input.md)
  is the Bootstrap 5.3 `<input class="form-control" type="file">`, so
  the browser draws the button and the file name — not Shiny’s “Browse”
  button beside a readonly text box, which is Bootstrap 3 markup.
- [`bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_input.md)
  /
  [`bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_range_input.md)
  are native `<input type="date">` fields, so the **browser** supplies
  the calendar. They do not delegate to Shiny, which would pull in
  `bootstrap-datepicker` — a third-party stylesheet whose calendar is
  nowhere in the Bootstrap docs. The cost is that `format`, `language`,
  `weekstart` and `datesdisabled` are gone; drive them with
  [`update_bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_date_input.md).
- Validation feedback needs
  [`bs_feedback()`](https://thinkr-open.github.io/bootstrict/reference/bs_feedback.md):
  Bootstrap only shows a message that is a *sibling* of the marked
  control, and a bare
  [`bs_invalid_feedback()`](https://thinkr-open.github.io/bootstrict/reference/bs_valid_feedback.md)
  after an input is a sibling of Shiny’s wrapper.
  [`set_bs_validation()`](https://thinkr-open.github.io/bootstrict/reference/set_bs_validation.md)
  switches the state from the server.

### `bs_button()` is an action button only when given an id

`bs_button("go", "Go")` behaves exactly like
[`shiny::actionButton()`](https://rdrr.io/pkg/shiny/man/actionButton.html)
— `input$go` is the click count. Called **without** an `id` it is an
inert, styled button; reactivity is opt-in.

### Interactive components are driven by `update_bs_*()`

Give a widget an `id` and it reports its state as `input$id` and takes
instructions from a matching helper:

| Widget | `input$id` | Server helper |
|----|----|----|
| [`bs_accordion()`](https://thinkr-open.github.io/bootstrict/reference/bs_accordion.md) | open panel value(s) | [`update_bs_accordion()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_accordion.md) |
| [`bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/bs_tabset.md) | active tab | [`update_bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_tabset.md) |
| [`bs_carousel()`](https://thinkr-open.github.io/bootstrict/reference/bs_carousel.md) | active slide | [`update_bs_carousel()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_carousel.md) |
| [`bs_collapse()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse.md) | open / closed | [`update_bs_collapse()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_collapse.md) |
| [`bs_list_group()`](https://thinkr-open.github.io/bootstrict/reference/bs_list_group.md) | selected item | [`update_bs_list_group()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_list_group.md) |
| [`bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md), [`bs_navbar_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_navbar.md) | active link | [`update_bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_nav.md) |
| [`bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/bs_pagination.md) | active page | [`update_bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_pagination.md) |
| [`bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md), [`bs_nav_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav_dropdown.md) | open / closed | [`show_bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_dropdown.md) … |
| [`bs_alert()`](https://thinkr-open.github.io/bootstrict/reference/bs_alert.md) | still on the page | [`close_bs_alert()`](https://thinkr-open.github.io/bootstrict/reference/close_bs_alert.md) |
| [`bs_progress()`](https://thinkr-open.github.io/bootstrict/reference/bs_progress.md) | — | [`update_bs_progress()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_progress.md) |

Tabs in particular use
[`bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/bs_tabset.md) +
[`bs_tab_panel()`](https://thinkr-open.github.io/bootstrict/reference/bs_tabset.md)
(an `id` is required and panels are validated) — not
[`tabsetPanel()`](https://rdrr.io/pkg/shiny/man/tabsetPanel.html) /
[`tabPanel()`](https://rdrr.io/pkg/shiny/man/tabPanel.html). For the
other widgets the `id` is optional: without one they are static markup,
which is what a decorative alert or a nav of plain links should be.

### Tooltips & popovers decorate an existing tag

`bs_tooltip(tag, "text")` and `bs_popover(tag, "content")` wrap a tag
you already have (pipe-friendly) and are initialised client-side by
`bootstrict` (Bootstrap does not auto-initialise them). They are UI-only
— there is no server-side `update` / `toggle` for them.

## Interactivity

Interactive components report state and are controllable from the
server:

``` r

ui <- bs_page(
  bs_accordion("acc",
    bs_accordion_panel("One", "...", value = "one"),
    bs_accordion_panel("Two", "...", value = "two")),
  bs_button("open_two", "Open panel two")
)

server <- function(input, output, session) {
  observe( print(input$acc) )                         # open panel value(s)
  observeEvent(input$open_two,
               update_bs_accordion("acc", open = "two"))
}
```

The same pattern covers tabs (`input$id` = active tab,
[`update_bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_tabset.md)),
the carousel (active slide,
[`update_bs_carousel()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_carousel.md)),
collapse, list-group selection, modals
([`show_bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_modal.md)
/
[`hide_bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_modal.md)),
offcanvas, toasts
([`show_bs_toast()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_toast.md),
[`bs_notify_toast()`](https://thinkr-open.github.io/bootstrict/reference/bs_notify_toast.md))
and progress bars
([`update_bs_progress()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_progress.md)).

## Coverage

**Layout** —
[`bs_container()`](https://thinkr-open.github.io/bootstrict/reference/bs_container.md),
[`bs_row()`](https://thinkr-open.github.io/bootstrict/reference/bs_row.md),
[`bs_col()`](https://thinkr-open.github.io/bootstrict/reference/bs_col.md)
(responsive spans, offsets, order, gutters, alignment),
[`bs_hstack()`](https://thinkr-open.github.io/bootstrict/reference/bs_hstack.md)
/
[`bs_vstack()`](https://thinkr-open.github.io/bootstrict/reference/bs_hstack.md)
stacks.

**Content** —
[`bs_table()`](https://thinkr-open.github.io/bootstrict/reference/bs_table.md)
(data frame → Bootstrap table),
[`bs_img()`](https://thinkr-open.github.io/bootstrict/reference/bs_img.md),
[`bs_figure()`](https://thinkr-open.github.io/bootstrict/reference/bs_figure.md),
[`bs_blockquote()`](https://thinkr-open.github.io/bootstrict/reference/bs_blockquote.md),
[`bs_display_heading()`](https://thinkr-open.github.io/bootstrict/reference/bs_display_heading.md),
[`bs_lead()`](https://thinkr-open.github.io/bootstrict/reference/bs_lead.md),
lists.

**Forms** — text / textarea / number / password / select / checkbox /
switch / radio / checkbox-group / range / color / file / date /
date-range inputs, the `.btn-check` segmented controls
([`bs_radio_button_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_button_input.md),
[`bs_checkbox_button_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_button_input.md)),
plus
[`bs_input_group()`](https://thinkr-open.github.io/bootstrict/reference/bs_input_group.md),
[`bs_floating_label()`](https://thinkr-open.github.io/bootstrict/reference/bs_floating_label.md),
[`bs_form()`](https://thinkr-open.github.io/bootstrict/reference/bs_form.md),
working validation feedback
([`bs_feedback()`](https://thinkr-open.github.io/bootstrict/reference/bs_feedback.md)
/
[`set_bs_validation()`](https://thinkr-open.github.io/bootstrict/reference/set_bs_validation.md)),
and `.form-check-reverse` via `reverse = TRUE`.

**Components** — accordion, alert, badge, breadcrumb, buttons & button
groups, card, carousel, close button, collapse, dropdown (standalone and
in a nav or navbar,
[`bs_nav_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav_dropdown.md)),
list group, modal, nav & tabs (including `.nav-underline`, 5.3), navbar,
offcanvas, pagination, placeholder, popover, progress (including
`.progress-stacked`, 5.3), spinner, toast, tooltip, scrollspy, plus
helpers
([`bs_ratio()`](https://thinkr-open.github.io/bootstrict/reference/bs_ratio.md),
[`bs_visually_hidden()`](https://thinkr-open.github.io/bootstrict/reference/bs_visually_hidden.md),
[`bs_vr()`](https://thinkr-open.github.io/bootstrict/reference/bs_vr.md),
[`bs_icon_link()`](https://thinkr-open.github.io/bootstrict/reference/bs_icon_link.md)).

**Colour modes (5.3)** — set the initial mode with
`bs_page(color_mode = "dark")`, or `"auto"` to follow the operating
system; switch it from the server with `set_bs_color_mode("light")` and
read the mode in force as `input$bootstrict_color_mode`. A mode the user
picks is remembered in the browser. Component-level `dark = TRUE` /
`theme = "dark"` arguments emit `data-bs-theme` per the 5.3 idiom.

**Utilities** — none are wrapped, deliberately. Every constructor takes
a trailing `class` and forwards named `...` as attributes, so a mockup’s
`class="p-4 text-center"` transfers verbatim and a utility Bootstrap
adds later works the day it ships.

See
[`?bootstrict`](https://thinkr-open.github.io/bootstrict/reference/bootstrict-package.md)
and run the demos:

``` r

# The catalogue: every widget, one card each.
shiny::runApp(system.file("examples/demo", package = "bootstrict"))

# The showcase: Quake Watch, a seismic monitor for the Fiji region built on
# datasets::quakes — designer theme from a _variables.scss sheet, offcanvas
# filter drawer, modal event records, colour modes, stacked progress.
shiny::runApp(system.file("examples/quakewatch", package = "bootstrict"))
```

## License

MIT © Colin Fay / ThinkR
