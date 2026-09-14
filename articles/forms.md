# Forms and inputs

``` r

library(shiny)
library(bootstrict)
```

Form inputs are where `bootstrict` stays closest to Shiny. **Most inputs
delegate to the matching `shiny::*Input()`** and only re-dress the
markup as Bootstrap 5 — so `input$id` and Shiny’s own `updateXxx()` work
exactly as you already know. Two native inputs have no Shiny equivalent
and get their own `update_bs_*()` helpers.

## The two families

| Family | Constructors | Reactive value | Update from server |
|----|----|----|----|
| **Delegating** (wrap Shiny) | text, textarea, numeric, password, select, checkbox, switch, radio, checkbox-group, file | `input$id` | Shiny’s `updateXxx()` |
| **Native** (own binding) | [`bs_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_range_input.md), [`bs_color_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_color_input.md), [`bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_input.md), [`bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_range_input.md), [`bs_radio_button_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_button_input.md), [`bs_checkbox_button_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_button_input.md) | `input$id` | [`update_bs_range()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_range.md), [`update_bs_color()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_color.md), [`update_bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_date_input.md), [`update_bs_toggle_buttons()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_toggle_buttons.md) |

Every input takes a leading `id`, an optional `label`, and — for
delegating inputs — a `help` string that renders as `.form-text` below
the control, plus a `width`. Where Bootstrap offers sizing,
`size = "sm"` or `"lg"` is available.

## Text-like inputs

``` r

bs_text_input("name", "Your name", placeholder = "Jane Doe")
bs_textarea_input("bio", "Bio", rows = 4)
bs_numeric_input("age", "Age", value = 30, min = 0, max = 120)
bs_password_input("pw", "Password", help = "Must be 8–20 characters.")
```

Signatures share a common shape;
[`bs_text_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_text_input.md)
is representative:

``` r

bs_text_input(
  id,
  label = NULL,
  value = "",
  ...,
  placeholder = NULL,
  size = NULL,      # "sm" or "lg"
  help = NULL,      # .form-text below the control
  width = NULL
)
```

Because these delegate to Shiny, update them with Shiny’s own updaters:

``` r

updateTextInput(session, "name", value = "Colin")
```

## Select

[`bs_select_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_select_input.md)
renders a **plain Bootstrap `<select class="form-select">`**. Note this
differs from Shiny’s
[`selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html):
selectize is off, so there is no search / tagging box.

``` r

bs_select_input("fruit", "Fruit", c("Apple", "Pear"))
bs_select_input(
  "sort_by", "Sort by",
  c("Magnitude" = "mag", "Depth" = "depth"),
  selected = "mag"
)
```

`multiple = TRUE` renders a multi-select listbox.

## Checkboxes, switches, radios and groups

A single checkbox, and its switch variant:

``` r

bs_checkbox_input("agree", "I agree", value = TRUE)
bs_checkbox_input("dark", "Dark mode", switch = TRUE)
bs_switch_input("dark", "Dark mode")            # convenience for switch = TRUE
```

Radio buttons and checkbox groups take `choices` (named or unnamed) and
an optional `selected`. `inline = TRUE` lays the choices out
horizontally:

``` r

bs_radio_input("size", "Size", c("S", "M", "L"), selected = "M")
bs_checkbox_group_input("opts", "Options", c("A", "B", "C"), selected = "A", inline = TRUE)
```

All of the check-style inputs support `reverse = TRUE`, which puts the
label before the control (`.form-check-reverse`).

## Range and colour (native inputs)

These two have no Shiny equivalent, so they ship their own bindings.
They still report `input$id`, but you drive them with the `bootstrict`
helpers — Shiny’s
[`updateSliderInput()`](https://rdrr.io/pkg/shiny/man/updateSliderInput.html)
will not reach them.

[`bs_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_range_input.md)
is a native `<input type="range">` (**not** Shiny’s
[`sliderInput()`](https://rdrr.io/pkg/shiny/man/sliderInput.html) — no
ticks, animation or ion.rangeSlider features):

``` r

bs_range_input("vol", "Volume", value = 50, min = 0, max = 100, step = 1)
```

If `value = NULL`, the browser starts it at the midpoint
`(min + max) / 2`. Update it from the server with
`update_bs_range(id, value)`:

``` r

update_bs_range("vol", 75)
```

[`bs_color_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_color_input.md)
is a native colour picker; `value` must be a 6-digit hex string:

``` r

bs_color_input("col", "Pick a colour", value = "#0d6efd")
update_bs_color("col", "#198754")
```

## Dates and files

``` r

bs_date_input("day", "Pick a day", value = "2026-06-26")
bs_date_range_input("range", "Period", start = "2026-01-01", end = "2026-12-31")
bs_file_input("upload", "Upload a file", accept = ".csv")
```

These delegate to
[`shiny::dateInput()`](https://rdrr.io/pkg/shiny/man/dateInput.html),
[`dateRangeInput()`](https://rdrr.io/pkg/shiny/man/dateRangeInput.html)
and [`fileInput()`](https://rdrr.io/pkg/shiny/man/fileInput.html)
respectively, so update them with the matching Shiny updater.

## Composing inputs

Three layout helpers restyle or group inputs without touching their
bindings.

### Input groups

[`bs_input_group()`](https://thinkr-open.github.io/bootstrict/reference/bs_input_group.md)
places add-ons and controls on a single line. When you pass a full
`bs_*_input()`, only its bare control is kept (its label and help text
are dropped, since the group is one line):

``` r

bs_input_group(
  bs_input_group_text("@"),
  bs_text_input("user", placeholder = "Username")
)

bs_input_group(
  bs_input_group_text("$"),
  bs_numeric_input("amount", value = 0),
  bs_input_group_text(".00"),
  size = "lg"
)
```

A handful of inputs whose binding lives on their container —
[`bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_input.md),
[`bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_range_input.md),
[`bs_file_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_file_input.md),
[`bs_radio_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_input.md)
and
[`bs_checkbox_group_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_checkbox_group_input.md)
— cannot be unwrapped into a group and will raise a clear error if you
try.

### Floating labels

[`bs_floating_label()`](https://thinkr-open.github.io/bootstrict/reference/bs_floating_label.md)
reshapes an input into the Bootstrap 5 floating-label style. It
**moves** the existing control rather than rebuilding it, so the binding
is preserved. If you do not pass a `label`, the control’s existing label
text is reused:

``` r

bs_floating_label(bs_text_input("email", "Email address"))
bs_floating_label(bs_select_input("fruit", "Fruit", c("Apple", "Pear")))
```

The same container-bound inputs listed above cannot be floated.

### Forms, labels, help and validation

[`bs_form()`](https://thinkr-open.github.io/bootstrict/reference/bs_form.md)
is a plain `<form>` wrapper for grouping controls; `novalidate = TRUE`
disables the browser’s native validation UI:

``` r

bs_form(
  bs_text_input("email", "Email"),
  bs_button("submit", "Submit", color = "primary")
)
```

The lower-level pieces are available when you hand-build a control:

- `bs_form_label("email", "Email address")` — a `.form-label` tied to a
  control by its `for` attribute.
- `bs_form_text("Must be 8–20 characters.")` — muted helper text (the
  same thing the `help=` argument produces).
- `bs_valid_feedback("Looks good!")` and
  `bs_invalid_feedback("Please choose a username.")` — inline validation
  messages that Bootstrap shows when the control is marked
  valid/invalid.

## Dates

[`bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_input.md)
is a native `<input type="date">` with the `.form-control` class, which
is what the Bootstrap 5.3 forms page shows: the **browser** supplies the
calendar.

It deliberately does not delegate to
[`shiny::dateInput()`](https://rdrr.io/pkg/shiny/man/dateInput.html),
which loads `bootstrap-datepicker` — a third-party stylesheet whose
calendar markup (`.datepicker`, `.datepicker-days`, …) appears nowhere
in the Bootstrap documentation and which a designer’s SASS sheet cannot
reach. The cost is real: `format`, `language`, `weekstart` and
`datesdisabled` are gone, because the browser owns the presentation and
Bootstrap offers no way to ask it for something else.

``` r

bs_date_input("day", "Day", value = "2026-06-26", min = "2026-01-01")
bs_date_range_input("period", "Period", start = "2026-01-01")
```

`input$day` is a `Date`, and `NA` while the field is empty. A range is a
length-2 `Date`, so it keeps both positions when only one end is filled
in. Drive them with
[`update_bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_date_input.md)
and
[`update_bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_date_input.md)
—
[`shiny::updateDateInput()`](https://rdrr.io/pkg/shiny/man/updateDateInput.html)
will not reach them. Pass `NA` to clear a field, and `NULL` (the
default) to leave it alone.

``` r

update_bs_date_input("day", value = Sys.Date())
update_bs_date_range_input("period", start = "2026-02-01", end = NA)
```

Bootstrap has no date-range component, so
[`bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_range_input.md)
is the assembly its docs prescribe: two fields in an `.input-group` with
an `.input-group-text` between them. Each field carries its own
`aria-label`, since one label cannot name both.

## Toggle buttons

Bootstrap’s segmented control is a row of buttons backed by hidden
`.btn-check` inputs. Its markup is not the `.form-check` one with a
different skin – the input is a *sibling* of its label – so these are
native controls with their own constructors, driven by
[`update_bs_toggle_buttons()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_toggle_buttons.md)
rather than
[`shiny::updateRadioButtons()`](https://rdrr.io/pkg/shiny/man/updateRadioButtons.html).

``` r

bs_radio_button_input("size", "Size", c(Small = "s", Large = "l"))
bs_checkbox_button_input("opts", "Options", c("a", "b"))
```

`input$size` is a single string; `input$opts` is a character vector,
empty when nothing is picked. `outline = FALSE`, `color`, `size` and
`vertical` cover the Bootstrap variants.

## Validation

Bootstrap only displays a feedback message when it is a *following
sibling* of the control carrying `.is-valid` / `.is-invalid`. A message
placed after a `bs_*_input()` is a sibling of shiny’s input container,
not of the control inside it, so it would never appear.
[`bs_feedback()`](https://thinkr-open.github.io/bootstrict/reference/bs_feedback.md)
puts it in the right place:

``` r

bs_feedback(
  bs_text_input("user", "Username"),
  invalid = "Please choose a username."
)
```

Declare the messages in the UI, then switch the state from the server
with
[`set_bs_validation()`](https://thinkr-open.github.io/bootstrict/reference/set_bs_validation.md):

``` r

observeEvent(input$submit, {
  if (input$user %in% taken) {
    set_bs_validation("user", "invalid", "That name is taken.")
  } else {
    set_bs_validation("user", "valid")
  }
})
```

`set_bs_validation(id, "none")` clears the state. Pass `state =` to
[`bs_feedback()`](https://thinkr-open.github.io/bootstrict/reference/bs_feedback.md)
when a control should render already marked.

The bare
[`bs_valid_feedback()`](https://thinkr-open.github.io/bootstrict/reference/bs_valid_feedback.md)
/
[`bs_invalid_feedback()`](https://thinkr-open.github.io/bootstrict/reference/bs_valid_feedback.md)
divs remain useful in a hand-built `<form>`, where you control the
sibling order yourself.

## Putting it together

A small settings form, driven from the server:

``` r

ui <- bs_page(
  bs_container(
    class = "py-4",
    bs_form(
      bs_floating_label(bs_text_input("email", "Email address")),
      bs_range_input("vol", "Volume", value = 50),
      bs_switch_input("notify", "Email me updates", value = TRUE),
      bs_button("save", "Save settings", color = "primary")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$save, {
    str(list(email = input$email, vol = input$vol, notify = input$notify))
    update_bs_range("vol", 50)          # native input → bootstrict helper
    updateTextInput(session, "email", value = "")  # delegating input → Shiny
  })
}

shinyApp(ui, server)
```
