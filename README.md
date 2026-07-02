# bootstrict

> Strict, faithful Bootstrap 5.3 widgets for Shiny — with minimum deviation from Shiny itself.

`bootstrict` re-implements the **Bootstrap 5.3** layout, content, forms and component library as Shiny UI functions.

## Why

Working with an external designer that doesn't know `{shiny}` can be complex because of two things:

- some Shiny components are _not_ plain Bootstrap;
- some Bootstrap components are _missing_ from Shiny.

`bootstrict` tries to fix this gap by giving you the whole Bootstrap 5 surface, and **nothing more**, meaning that you can tell a designer: "you can use anything from Bootstrap 5.3. But nothing more".

## Installation

```r
# install.packages("pak")
pak::pak("thinkr-open/bootstrict")
```

The Bootstrap 5.3 runtime and SASS compilation are provided by [`bslib`](https://rstudio.github.io/bslib/) — there is nothing else to vendor, and the markup bootstrict emits matches the runtime it runs on.

## The designer hand-off

Every widget mirrors the Bootstrap 5.3 HTML structure **one-to-one**, so a designer's mockup (for example in Figma) and exported SASS variables drop straight into a Shiny app. Interactive components report their state to the server and can be driven from the server with `update_*()` helpers.

The motivating workflow: a designer works in Figma, stays strictly within [the Bootstrap 5.3 docs](https://getbootstrap.com/docs/5.3), and exports a `_variables.scss` sheet.

You received a Figma mockup and the variables, and can implement this directly into shiny.

```r
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

`bootstrict_theme()` is a thin wrapper over `bslib::bs_theme()` pinned to
Bootstrap 5; `parse_scss_variables()` turns a `$name: value;` sheet into the
named list `bslib` expects. Inline overrides win over the file:

```r
bootstrict_theme(
  variables = "_variables.scss",
  primary = "#ff6600"
)
```

## Conventions (minimum deviation from Shiny)

- Every constructor is `snake_case`, prefixed `bs_` (no masking of Shiny).
- `...` works exactly like Shiny/htmltools: **named** args become HTML
  attributes, **unnamed** args become children.
- Interactive widgets take a leading `id`; their value is `input$id`.
- **Form inputs delegate to the matching `shiny::*Input()`**, so the reactive
  value and every `updateXxx()` keep working identically — `bootstrict` only
  layers Bootstrap 5 markup, sizing, help text, switches, input groups and
  floating labels on top.

## How bootstrict differs from Shiny

`bootstrict` stays as close to Shiny as it can, but a handful of behaviours
differ **on purpose** (to follow native Bootstrap). If you already know Shiny,
these are the things to watch for.

### Overlay widgets live in the UI — they aren't built from the server

Shiny builds modals and notifications on the server (`showModal(modalDialog(...))`, `showNotification(...)`). `bootstrict` follows the native Bootstrap pattern instead: the modal, toast or offcanvas is declared **once in the UI** with an `id`, and the server only **opens or closes it by id**.

```r
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

| Task               | Shiny                         | bootstrict                                                                              |
| ------------------ | ----------------------------- | --------------------------------------------------------------------------------------- |
| Open a modal       | `showModal(modalDialog(...))` | declare `bs_modal("id", …)`, then `show_bs_modal("id")`                                 |
| Close a modal      | `removeModal()`               | `hide_bs_modal("id")`                                                                   |
| Notification       | `showNotification("…")`       | `bs_notify_toast("…")` — the one server-built widget (builds + shows a transient toast) |
| Offcanvas / drawer | _(not in Shiny)_              | declare `bs_offcanvas("id", …)`, then `show_bs_offcanvas("id")`                         |

Two consequences:

- **Place overlay widgets at the top level of the page** (a direct child of
  `bs_page()` / `bs_container()`), _not_ nested inside a `bs_card()` or other
  positioned element — Bootstrap can otherwise clip or mis-position them.
- Every overlay reports its **open state** back as `input$id` (`TRUE` when
  shown) — Shiny modals don't. You can also open them with **no server round
  trip** using the UI triggers `bs_modal_trigger()`, `bs_offcanvas_trigger()`
  and `bs_collapse_trigger()`.

### Server helpers take `id` first and `session` last

Shiny's updaters take the session first: `updateTextInput(session, "id", …)`.
Every `bootstrict` helper takes the **id first** and the **session last and
optional** (it defaults to the current reactive domain), and ids are namespaced
automatically inside modules:

```r
update_bs_tabset("tabs", selected = "profile")   # no session argument needed
show_bs_modal("info")
```

### Two kinds of inputs

1. **Inputs that delegate to Shiny** — `bs_text_input()`, `bs_numeric_input()`,
   `bs_select_input()`, `bs_radio_input()`, `bs_checkbox_input()`,
   `bs_checkbox_group_input()`, `bs_date_input()`, `bs_date_range_input()`,
   `bs_file_input()`, `bs_textarea_input()`, `bs_password_input()`. They wrap the
   matching `shiny::*Input()` and only restyle the markup, so `input$id` **and
   Shiny's own `updateXxx()` keep working unchanged** — use
   `shiny::updateTextInput()` etc. for these.
2. **Native inputs with no Shiny equivalent** — `bs_range_input()` and
   `bs_color_input()`. They ship their own bindings, so drive them with
   `update_bs_range()` / `update_bs_color()` (Shiny's `updateSliderInput()`
   won't reach them).

Two specifics worth knowing:

- `bs_select_input()` renders a **plain Bootstrap `<select>`** — selectize is
  off, so there is no search / tagging box that Shiny's `selectInput()` adds by
  default.
- `bs_range_input()` is a native HTML `<input type="range">`, **not** Shiny's
  `sliderInput()` (no ticks, animation or ion.rangeSlider features).

### `bs_button()` is an action button only when given an id

`bs_button("go", "Go")` behaves exactly like `shiny::actionButton()` — `input$go`
is the click count. Called **without** an `id` it is an inert, styled button;
reactivity is opt-in.

### Interactive components are driven by `update_bs_*()`

Accordion, tabset, carousel, collapse, list-group and progress report their
state as `input$id` and are controlled with `update_bs_accordion()`,
`update_bs_tabset()`, `update_bs_carousel()`, `update_bs_collapse()`,
`update_bs_list_group()` and `update_bs_progress()`. Tabs in particular use
`bs_tabset()` + `bs_tab_panel()` (an `id` is required and panels are validated) —
not `tabsetPanel()` / `tabPanel()`.

### Tooltips & popovers decorate an existing tag

`bs_tooltip(tag, "text")` and `bs_popover(tag, "content")` wrap a tag you already
have (pipe-friendly) and are initialised client-side by `bootstrict` (Bootstrap
does not auto-initialise them). They are UI-only — there is no server-side
`update` / `toggle` for them.

## Interactivity

Interactive components report state and are controllable from the server:

```r
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

The same pattern covers tabs (`input$id` = active tab, `update_bs_tabset()`),
the carousel (active slide, `update_bs_carousel()`), collapse, list-group
selection, modals (`show_bs_modal()` / `hide_bs_modal()`), offcanvas, toasts
(`show_bs_toast()`, `bs_notify_toast()`) and progress bars
(`update_bs_progress()`).

## Coverage

**Layout** — `bs_container()`, `bs_row()`, `bs_col()` (responsive spans,
offsets, order, gutters, alignment), `bs_hstack()` / `bs_vstack()` stacks.

**Content** — `bs_table()` (data frame → Bootstrap table), `bs_img()`,
`bs_figure()`, `bs_blockquote()`, `bs_display_heading()`, `bs_lead()`, lists.

**Forms** — text / textarea / number / password / select / checkbox / switch /
radio / checkbox-group / range / color / file / date / date-range inputs, plus
`bs_input_group()`, `bs_floating_label()`, `bs_form()`, validation feedback, and
`.form-check-reverse` via `reverse = TRUE`.

**Components** — accordion, alert, badge, breadcrumb, buttons & button groups,
card, carousel, close button, collapse, dropdown, list group, modal, nav &
tabs (including `.nav-underline`, 5.3), navbar, offcanvas, pagination,
placeholder, popover, progress (including `.progress-stacked`, 5.3), spinner,
toast, tooltip, scrollspy, plus helpers (`bs_ratio()`, `bs_visually_hidden()`,
`bs_vr()`, `bs_icon_link()`).

**Colour modes (5.3)** — set the initial mode with
`bs_page(color_mode = "dark")` and switch it from the server with
`set_bs_color_mode("light")`; component-level `dark = TRUE` / `theme = "dark"`
arguments emit `data-bs-theme` per the 5.3 idiom.

See `?bootstrict` and run the demo:

```r
shiny::runApp(system.file("examples/demo", package = "bootstrict"))
```

## License

MIT © Colin Fay / ThinkR
