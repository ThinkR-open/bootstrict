# Changelog

## bootstrict (development version)

### New widgets

- Colour modes follow the operating system.
  `bs_page(color_mode = "auto")` resolves the mode from
  `prefers-color-scheme` before the page paints, so there is no flash of
  the wrong theme, and `set_bs_color_mode("auto")` hands control back to
  the OS. A mode the user chose is remembered in the browser and
  survives a reload. The mode in force is reported as
  `input$bootstrict_color_mode`, always `"light"` or `"dark"`, so the
  server can render to match. An app that never mentions `color_mode` is
  untouched.

- `update_bs_carousel(action =)` pauses and resumes cycling.

- [`bs_scrollspy()`](https://thinkr-open.github.io/bootstrict/reference/bs_scrollspy.md)
  takes Bootstrap 5.3’s observer options, `root_margin` and `threshold`;
  `offset` is deprecated upstream, which the documentation now says.

- [`bs_tooltip()`](https://thinkr-open.github.io/bootstrict/reference/bs_tooltip.md)
  and
  [`bs_popover()`](https://thinkr-open.github.io/bootstrict/reference/bs_popover.md)
  accept `placement = "auto"`.

- [`bs_table()`](https://thinkr-open.github.io/bootstrict/reference/bs_table.md)
  covers the rest of the Bootstrap tables page: `striped` now takes
  `"columns"` as well as `TRUE`/`"rows"` (`.table-striped-columns`), and
  `head_variant`, `group_divider`, `row_variant` and `caption_top` give
  the generated markup its `<thead>` colour, the `.table-group-divider`,
  the per-row `.table-*` accents and `.caption-top`. `row_variant` is
  recycled across the rows, and `NA` leaves one unstyled.

- `bs_navbar_nav(id =)` reports its active link as `input$id`, like
  `bs_nav(id =)`, and takes one from
  [`update_bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_nav.md).
  Bootstrap has no “navbar page” component – switching content is the
  application’s job – and this is what makes that pattern expressible;
  the navigation vignette now shows it.

- [`bs_radio_button_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_button_input.md)
  and
  [`bs_checkbox_button_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_button_input.md)
  render Bootstrap’s segmented control (`.btn-check`), which had no
  equivalent: its input is a *sibling* of its label, with
  `autocomplete="off"` and no wrapper, so it cannot come out of shiny’s
  `generateOptions()`. They are native controls, driven by
  [`update_bs_toggle_buttons()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_toggle_buttons.md).
  A checkbox group reports a character vector, `character(0)` when
  nothing is picked.

- `bs_nav(id =)` reports the `value` of its active link as `input$id`
  and takes one from the server with
  [`update_bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_nav.md);
  [`bs_nav_link()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md)
  gains a `value` (defaulting to its text). Clicking a link activates it
  without jumping to the top of the page, so a nav can be used as a
  selector.

- `bs_pagination(id =)` and `bs_pagination_numbered(id =)` report the
  active page as `input$id` and take one from
  [`update_bs_pagination()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_pagination.md);
  [`bs_page_item()`](https://thinkr-open.github.io/bootstrict/reference/bs_page_item.md)
  gains a `value`. In a numbered pager the arrows now step through the
  pages and disable themselves at either end, instead of being inert
  links.

- `bs_dropdown(id =)` and `bs_nav_dropdown(id =)` report their open
  state as `input$id`, and
  [`show_bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_dropdown.md)
  /
  [`hide_bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_dropdown.md)
  /
  [`toggle_bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_dropdown.md)
  drive them from the server. Bootstrap emits `shown.bs.dropdown` and
  exposes the methods; neither was reachable.

- `bs_alert(id =)` reports whether the alert is still on the page as
  `input$id`, and
  [`close_bs_alert()`](https://thinkr-open.github.io/bootstrict/reference/close_bs_alert.md)
  dismisses it from the server. Alerts are interactive in Bootstrap, but
  reported nothing and had no server helper.

- [`bs_nav_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav_dropdown.md)
  builds the menu a designer draws in a navbar: an
  `<li class="nav-item dropdown">` whose toggle is a `.nav-link`, per
  the Bootstrap reference.
  [`bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md)
  emits a standalone `<div class="dropdown">` with a
  `<button class="btn">`, which is invalid as a direct child of the
  `<ul class="navbar-nav">` that
  [`bs_navbar_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_navbar.md)
  and
  [`bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md)
  produce, and renders as a grey button rather than a nav link — yet
  [`bs_navbar()`](https://thinkr-open.github.io/bootstrict/reference/bs_navbar.md)’s
  own documentation used to recommend it. Takes the same menu items,
  plus `active` / `disabled` / `align` / `dark`.

- [`bs_feedback()`](https://thinkr-open.github.io/bootstrict/reference/bs_feedback.md)
  and
  [`set_bs_validation()`](https://thinkr-open.github.io/bootstrict/reference/set_bs_validation.md)
  make validation feedback work. Bootstrap only displays a
  `.valid-feedback` / `.invalid-feedback` message when it is a
  *following sibling* of the control carrying `.is-valid` /
  `.is-invalid`. Every `bs_*_input()` returns its control wrapped in
  shiny’s `div.form-group.shiny-input-container`, so a
  [`bs_invalid_feedback()`](https://thinkr-open.github.io/bootstrict/reference/bs_valid_feedback.md)
  placed after the input was a sibling of the *wrapper*, never of the
  control, and stayed `display: none` — the pattern the forms vignette
  and the demo app both showed could not work.
  `bs_feedback(input, valid =, invalid =)` inserts the messages next to
  the control itself (once after the last option, for a choice group),
  takes an optional initial `state =`, and
  `set_bs_validation(id, state, message)` switches the state and the
  message text from the server.

- [`bs_download_button()`](https://thinkr-open.github.io/bootstrict/reference/bs_download_button.md)
  and
  [`bs_download_link()`](https://thinkr-open.github.io/bootstrict/reference/bs_download_link.md)
  wrap
  [`shiny::downloadButton()`](https://rdrr.io/pkg/shiny/man/downloadButton.html)
  /
  [`shiny::downloadLink()`](https://rdrr.io/pkg/shiny/man/downloadButton.html).
  shiny hardcodes the Bootstrap 3 class `.btn-default` on the download
  button, which has no Bootstrap 5 equivalent and leaves the button
  unstyled; the wrapper swaps it for a real 5.3 variant and takes
  `color` / `outline` / `size` like
  [`bs_button()`](https://thinkr-open.github.io/bootstrict/reference/bs_button.md).
  shiny’s download plumbing (the `shiny-download-link` class, `href` /
  `target` / `download` and the auto-enable dance) is left intact, so
  the server side stays a plain
  [`shiny::downloadHandler()`](https://rdrr.io/pkg/shiny/man/downloadHandler.html).
  `icon` defaults to `NULL` rather than shiny’s Font Awesome icon, which
  is outside Bootstrap 5.

### New showcase app

- `inst/examples/quakewatch`: Quake Watch, a realistic demo (a seismic
  monitor for the Fiji region built on
  [`datasets::quakes`](https://rdrr.io/r/datasets/quakes.html))
  complementing the exhaustive widget catalogue in `inst/examples/demo`.
  It exercises the designer hand-off
  (`bootstrict_theme(variables = "_variables.scss")`), UI-declared
  overlays (offcanvas filter drawer, modal event records, toasts),
  state-reporting components driven by `update_bs_*()`, and the 5.3
  surface (colour modes, `.nav-underline`, `.progress-stacked`). Run it
  with
  `shiny::runApp(system.file("examples/quakewatch", package = "bootstrict"))`.

### Bootstrap upgrade

The package now targets **Bootstrap 5.3** (5.3.8, the runtime `bslib`
actually ships) instead of 5.2, resolving the former 5.2-markup /
5.3-runtime split.

- Colour modes:
  [`bs_page()`](https://thinkr-open.github.io/bootstrict/reference/bs_page.md)
  /
  [`bs_page_fluid()`](https://thinkr-open.github.io/bootstrict/reference/bs_page.md)
  /
  [`bs_page_fillable()`](https://thinkr-open.github.io/bootstrict/reference/bs_page.md)
  gain `color_mode` (initial `data-bs-theme` on the page body) and the
  new
  [`set_bs_color_mode()`](https://thinkr-open.github.io/bootstrict/reference/set_bs_color_mode.md)
  switches it from the server. The dark variants of navbar
  (`theme = "dark"`), dropdown and carousel (`dark = TRUE`) and the
  close button (`white = TRUE`) now emit `data-bs-theme="dark"` — their
  5.2-era classes (`.navbar-dark`, `.dropdown-menu-dark`,
  `.carousel-dark`, `.btn-close-white`) are deprecated in 5.3.
- Progress uses the 5.3 markup: `role="progressbar"` and the
  `aria-value*` attributes live on the `.progress` track (which now
  carries the `id`), the inner `.progress-bar` is purely visual, and
  passing several bars to
  [`bs_progress()`](https://thinkr-open.github.io/bootstrict/reference/bs_progress.md)
  renders a `.progress-stacked` group.
  [`bs_progress_bar()`](https://thinkr-open.github.io/bootstrict/reference/bs_progress.md)
  gains `aria_label`.
- New 5.3 surface:
  [`bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md)
  /
  [`bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/bs_tabset.md)
  accept `type = "underline"`,
  [`bs_img()`](https://thinkr-open.github.io/bootstrict/reference/bs_img.md)
  gains `object_fit` (`.object-fit-*`),
  [`bs_icon_link()`](https://thinkr-open.github.io/bootstrict/reference/bs_icon_link.md)
  renders the icon-link helper, and `bs_navbar(bg =)` accepts `"body"`,
  `"body-secondary"`, `"body-tertiary"`, `"white"`, `"black"`,
  `"transparent"`.
- 5.3 reference markup details:
  [`bs_card_subtitle()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
  uses `text-body-secondary` (`.text-muted` is deprecated),
  [`bs_modal_title()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
  is an `<h1 class="modal-title fs-5">` again, tab panes carry
  `tabindex="0"`, tooltips/popovers use `data-bs-title` (no more
  native-tooltip flash), and `help =` text is wired to its control via
  `aria-describedby`.

### Breaking changes

- [`bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_input.md)
  and
  [`bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_range_input.md)
  are native `<input type="date">` fields and no longer delegate to
  [`shiny::dateInput()`](https://rdrr.io/pkg/shiny/man/dateInput.html),
  which loads `bootstrap-datepicker` — a third-party stylesheet whose
  calendar markup (`.datepicker`, `.datepicker-days`, …) appears nowhere
  in the Bootstrap documentation and which a designer’s SASS sheet
  cannot reach. That contradicted the one promise the package makes, so
  it is gone; the browser now supplies the calendar, as the Bootstrap
  5.3 forms page has it. No third-party widget library is shipped any
  more, and a test enforces that.

  What that costs: `format`, `language`, `weekstart` and `datesdisabled`
  are gone, since the browser owns the presentation and Bootstrap offers
  no way to ask it for another.
  [`shiny::updateDateInput()`](https://rdrr.io/pkg/shiny/man/updateDateInput.html)
  no longer reaches these controls — use
  [`update_bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_date_input.md)
  /
  [`update_bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_date_input.md),
  which take `NA` to clear a field and `NULL` to leave it alone.
  `input$id` is still a `Date`, `NA` while the field is empty, and a
  range is still a length-2 `Date`.
  [`bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_range_input.md)
  gains `separator`, and the container now carries the id while the
  field takes a derived one, so the two no longer collide.

- [`bs_img()`](https://thinkr-open.github.io/bootstrict/reference/bs_img.md),
  [`bs_card_img()`](https://thinkr-open.github.io/bootstrict/reference/bs_card.md)
  and
  [`bs_figure_img()`](https://thinkr-open.github.io/bootstrict/reference/bs_figure.md)
  default `alt` to `""` rather than `NULL`. An `<img>` with no `alt`
  attribute at all is announced by its file name; an empty one marks the
  image decorative, which is the right default for one the caller did
  not describe.

- [`bs_file_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_file_input.md)
  emits the Bootstrap 5.3 markup: a plain
  `<input class="form-control" type="file">`. shiny builds the Bootstrap
  3 compound widget instead — a “Browse” button beside a readonly text
  box showing the file name, with the real input hidden off-screen —
  which is not in the Bootstrap 5.3 docs at all, so a designer had no
  way to draw it. Only shiny’s own element and its progress bar are
  kept, so uploads and `input$id` are unchanged; the browser draws the
  button and the file name itself. The `button_label` and `placeholder`
  arguments are gone with the widget they configured, and `size` and
  `help` are now accepted like on the other controls.

- `bs_nav_dropdown(id =)` now sets the id on the root `<li>` rather than
  on the toggle `<a>`, so it addresses the widget the way every other
  interactive constructor does and the new state reporting and server
  helpers can find it. This only affects code written against the
  unreleased
  [`bs_nav_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav_dropdown.md).

- `bs_table(data)` now renders a data frame’s row names as the reference
  `<th scope="row">` header cell, so `bs_table(head(mtcars))` keeps the
  car names it used to drop. This adds a leading column for frames that
  carry real row names; automatic row names (a tibble, a freshly built
  data frame) are unaffected. The new `rownames` argument forces the
  behaviour either way.

- [`bs_page_fillable()`](https://thinkr-open.github.io/bootstrict/reference/bs_page.md)
  loses its `fillable` argument:
  [`bslib::page_fillable()`](https://rstudio.github.io/bslib/reference/page_fillable.html)
  has no such parameter, so the value leaked into the page markup as an
  invalid `fillable` HTML attribute and controlled nothing.

- `bs_modal(backdrop = FALSE)` now renders a modal with *no* backdrop
  (`data-bs-backdrop="false"`), matching Bootstrap and
  [`bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas.md).
  Use `backdrop = "static"` for a backdrop that does not dismiss on
  outside click (the previous behaviour of `FALSE`).

- [`bs_input_group()`](https://thinkr-open.github.io/bootstrict/reference/bs_input_group.md)
  and
  [`bs_floating_label()`](https://thinkr-open.github.io/bootstrict/reference/bs_floating_label.md)
  now raise an error when given an input whose Shiny binding lives on
  its container
  ([`bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_input.md),
  [`bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_range_input.md),
  [`bs_file_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_file_input.md),
  [`bs_radio_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_input.md),
  [`bs_checkbox_group_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_checkbox_group_input.md)).
  Previously they silently emitted a dead control with no id, binding,
  or dependencies.

- Layout constructors now validate their scales instead of emitting
  non-existent classes:
  [`bs_col()`](https://thinkr-open.github.io/bootstrict/reference/bs_col.md)
  spans (1-12, `"auto"`, `TRUE`), `bs_row(cols=)` (1-6, `"auto"`),
  gutters and stack `gap` (0-5), `offset` (0-11), `order` (0-5,
  `"first"`, `"last"`), heading `level`s (1-6),
  `bs_pagination_numbered(current=)` (1..n), `bs_color_input(value=)`
  (`#rrggbb`), and `bs_tabset(selected=)` must match a panel value.

- [`bs_notify_toast()`](https://thinkr-open.github.io/bootstrict/reference/bs_notify_toast.md)
  requires plain-text `body`/`title` (they are rendered via
  `textContent`; tags now raise an error instead of displaying raw
  markup or `[object Object]`), and its `...` must be empty.

### Bug fixes

- The natively built controls no longer carry shiny’s classes.
  [`bs_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_range_input.md),
  [`bs_color_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_color_input.md),
  [`bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_input.md),
  [`bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_range_input.md)
  and the two toggle-button controls emitted `.shiny-input-container`
  and `.form-group` although they build their own markup and their own
  binding. Neither is read by shiny’s JavaScript, but shiny’s
  *stylesheet* caps `.shiny-input-container` at `width: 300px` — so a
  segmented button group was clipped to 300px by CSS that is not
  Bootstrap’s, and `.form-range` was not the full-width control
  Bootstrap draws. `.form-group` is a dead Bootstrap 3 class besides.
  [`bs_file_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_file_input.md)
  keeps `.form-group` alone: shiny’s binding finds the upload progress
  bar with `closest("div.form-group")`.

- `data-bs-theme` is now set on the document root rather than the
  `<body>`. Bootstrap’s `color-scheme` declaration is what tells the
  browser to paint scrollbars and native controls dark, and it only
  reaches them from `<html>`.

- Dropdown options now reach the element Bootstrap reads them from.
  Passing `data-bs-auto-close` through `...` put it on the `.dropdown`
  wrapper, while Bootstrap only ever looks at the toggle, so it did
  nothing. `auto_close`, `offset` and `reference` are arguments and land
  on the toggle.

- [`bs_carousel()`](https://thinkr-open.github.io/bootstrict/reference/bs_carousel.md)
  no longer emits a duplicated `data-bs-ride`. Passing it through `...`
  produced `data-bs-ride="carousel true"`, which is not a value.
  `autoplay = "resume"` is Bootstrap’s `"true"`, and `wrap`, `keyboard`,
  `pause` and `touch` are arguments.

- A batch of small markup defects:

  - [`bs_tab_panel()`](https://thinkr-open.github.io/bootstrict/reference/bs_tabset.md)
    and
    [`bs_accordion_panel()`](https://thinkr-open.github.io/bootstrict/reference/bs_accordion.md)
    applied their *named* `...` as body text instead of attributes, so
    `data-bs-theme = "dark"` showed up as visible text in the panel.
  - A tag title gave an escaped value: `bs_tab_panel(span("Home"), …)`
    reported `data-value="&lt;span&gt;Home&lt;/span&gt;"`. The value is
    now taken from the title’s text, and a title with no text asks for
    an explicit `value`.
  - [`bs_input_group()`](https://thinkr-open.github.io/bootstrict/reference/bs_input_group.md)
    dropped the `.form-text` node but kept the control’s
    `aria-describedby`, leaving a dangling ARIA reference.
  - [`bs_floating_label()`](https://thinkr-open.github.io/bootstrict/reference/bs_floating_label.md)
    put a `placeholder` on a `<select>`, which has no such attribute.
  - [`bs_collapse_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse_trigger.md)
    given several targets kept only the first in `data-bs-target` while
    listing them all in `aria-controls`; Bootstrap resolves that
    attribute with `querySelectorAll`, so the documented multiple-target
    pattern now works.
  - [`bs_scrollspy()`](https://thinkr-open.github.io/bootstrict/reference/bs_scrollspy.md)
    inside a hidden tab pane never activated and reported nothing:
    Bootstrap measured a zero-height container. It is refreshed when its
    tab is shown.
  - `bs_nav_link(disabled = TRUE)` kept `href="#"` without
    `tabindex="-1"`, so a disabled link stayed keyboard-activatable.
  - `bs_table(align =)` was not validated, so any string became a
    non-existent `.align-*` class.
  - A hand-composed
    [`bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
    had no accessible name at all; `aria-labelledby` was only ever set
    by the `title` shortcut, and now points at a composed
    [`bs_modal_title()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md).

- Forgetting the leading `id` of an interactive widget now raises an
  error instead of rendering silently.
  [`bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/bs_tabset.md),
  [`bs_accordion()`](https://thinkr-open.github.io/bootstrict/reference/bs_accordion.md),
  [`bs_carousel()`](https://thinkr-open.github.io/bootstrict/reference/bs_carousel.md),
  [`bs_collapse()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse.md),
  [`bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md),
  [`bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas.md)
  and
  [`bs_toast()`](https://thinkr-open.github.io/bootstrict/reference/bs_toast.md)
  take their id first, so the first child landed on `id`:
  `bs_tabset(bs_tab_panel("A", "a"))` rendered an empty `<ul>` whose id
  was the deparsed panel object. On an API whose central convention is
  “the id comes first”, that is the mistake everyone makes.

- [`bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/bs_tabset.md),
  [`bs_accordion()`](https://thinkr-open.github.io/bootstrict/reference/bs_accordion.md),
  [`bs_carousel()`](https://thinkr-open.github.io/bootstrict/reference/bs_carousel.md)
  and
  [`bs_progress()`](https://thinkr-open.github.io/bootstrict/reference/bs_progress.md)
  accept children built with
  [`lapply()`](https://rdrr.io/r/base/lapply.html). Generating panels in
  a loop is the usual thing to do in a data-driven app, and
  `dev/CONVENTIONS.md` says to let htmltools flatten lists, but each
  constructor validated the type of its children first and so saw the
  list itself: `bs_tabset("t", lapply(...))` failed with “All `...`
  arguments must be
  [`bs_tab_panel()`](https://thinkr-open.github.io/bootstrict/reference/bs_tabset.md)s”.
  Children are now flattened before the check, without descending into a
  panel object, which is itself a classed list.

- [`bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_range_input.md)
  no longer renders small whatever you asked, and its separator is a
  real Bootstrap 5 add-on. shiny hardcodes `.input-group-sm` on the
  group, and wraps the ” to ” text in a Bootstrap 3
  `<span class="input-group-addon input-group-prepend input-group-append">`;
  add-ons must be *direct* children of `.input-group` under Bootstrap 5,
  or the corner rounding between the two fields breaks. The size is now
  decided by a `size` argument.

- [`shiny::updateRadioButtons()`](https://rdrr.io/pkg/shiny/man/updateRadioButtons.html)
  and
  [`shiny::updateCheckboxGroupInput()`](https://rdrr.io/pkg/shiny/man/updateCheckboxGroupInput.html)
  no longer strip the Bootstrap 5 markup off
  [`bs_radio_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_input.md)
  and
  [`bs_checkbox_group_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_checkbox_group_input.md).
  Both replace the whole options block with HTML generated server-side
  by `shiny:::generateOptions()`, which has no theme branch and always
  emits Bootstrap 3 (`<div class="radio"><label><input>`); bootstrict’s
  enhancement ran once, at render time, so the first update with
  `choices` silently lost `.form-check`, `.form-check-input` and
  `.form-check-label`. The classes are now put back client-side, which
  keeps the documented promise that shiny’s own updaters work unchanged
  — `inline` and `reverse` cannot be recovered from the replaced HTML,
  so they are recorded on the container.

- The package tarball no longer ships an internal Posit Connect
  deployment record
  (`inst/examples/quakewatch/rsconnect/…/quakewatch.dcf`, carrying a
  server host name and a user name). `.Rbuildignore` now excludes any
  `inst/examples/*/rsconnect` directory.

- [`bs_table()`](https://thinkr-open.github.io/bootstrict/reference/bs_table.md)
  no longer renders the wrong values for a tibble. Cells were extracted
  with `data[i, j]`, which drops to a vector for a `data.frame` but
  keeps a 1x1 frame for a tibble, so
  [`as.character()`](https://rdrr.io/r/base/character.html) rendered the
  underlying storage: a factor as its integer code, a `Date` as its day
  number. Cells are now read from the column.

- [`bs_table()`](https://thinkr-open.github.io/bootstrict/reference/bs_table.md)
  formats numbers the way a reader expects.
  [`as.character()`](https://rdrr.io/r/base/character.html) rendered
  `100000` as `"1e+05"` and `1/3` with fifteen significant digits.

- An `.input-group-text` addon holding a checkbox is no longer
  destroyed.
  [`bs_input_group()`](https://thinkr-open.github.io/bootstrict/reference/bs_input_group.md)
  descended into any child containing a `.shiny-input-container` and
  returned the first control it found, discarding everything around it,
  so
  `bs_input_group(bs_input_group_text(bs_checkbox_input("cb", NULL)), …)`
  lost its `<span class="input-group-text">` and left the checkbox as a
  bare sibling of the text input. Addons are now passed through
  untouched, and
  [`bs_input_group_text()`](https://thinkr-open.github.io/bootstrict/reference/bs_input_group.md)
  builds Bootstrap’s documented addon: a lone `.form-check-input.mt-0`,
  without the `.shiny-input-container` and `.form-check` wrappers whose
  indent is meant for a labelled control in a form.

- [`bs_list_unstyled()`](https://thinkr-open.github.io/bootstrict/reference/bs_list_unstyled.md)
  and
  [`bs_list_inline()`](https://thinkr-open.github.io/bootstrict/reference/bs_list_unstyled.md)
  no longer nest an `<li>` inside an `<li>`. Every child was wrapped in
  a fresh `<li>`, including one that already was an `<li>` — the usage
  the content vignette documents for richer items. The HTML parser
  closes the outer item at the inner start tag, so what survived was an
  empty `<li class="list-inline-item">` followed by a bare `<li>`
  carrying none of the list’s classes, which breaks the inline layout
  and made the Bootstrap nested-list example unreachable. An `<li>`
  child is now passed through (gaining `.list-inline-item` where it
  applies), and a child that is a bare list (an
  [`lapply()`](https://rdrr.io/r/base/lapply.html) result, a
  [`tagList()`](https://rstudio.github.io/htmltools/reference/tagList.html))
  is expanded into one item per element instead of being wrapped whole
  in one `<li>`.

- `bs_progress(height =)` no longer wipes out a stacked group. Each
  segment received two separate `style` attributes, and htmltools joins
  duplicated attributes with a space rather than `"; "`, so the rendered
  attribute was `style="width: 15% height: 10px"` — a single malformed
  declaration the browser drops entirely. The segments came out
  zero-width (invisible) as soon as `height` was supplied. Width and
  height are now one declaration.

- The close button of a responsive
  [`bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas.md)
  now closes it. A responsive panel carries `.offcanvas-{bp}` *instead
  of* `.offcanvas`, and Bootstrap’s dismiss handler resolves its target
  as `getElementFromSelector(this) || this.closest(".offcanvas")`: with
  no explicit target it found nothing, threw
  `TypeError: Cannot read properties of undefined (reading 'backdrop')`
  and left the panel open. The header close button now carries an
  explicit `data-bs-target` (escaped, so module ids work), which is
  harmless on a plain offcanvas since it resolves to the same element.

- A hand-composed
  [`bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
  no longer nests its header and footer inside a `.modal-body`.
  [`bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)’s
  own documentation invites composing the dialog with
  [`bs_modal_header()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
  /
  [`bs_modal_body()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
  /
  [`bs_modal_footer()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md),
  but every unnamed child was wrapped in a `.modal-body` regardless, so
  the documented path produced
  `.modal-content > .modal-body > (.modal-header, .modal-body, .modal-footer)`
  — invalid structure that breaks the sticky header and the scrollable
  body. Children that already carry one of those classes are now emitted
  as siblings of `.modal-content`; bare children are still wrapped, in
  place, so the two styles can be mixed.

- Re-rendering a
  [`bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
  or
  [`bs_offcanvas()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas.md)
  while it is open no longer leaves the page permanently unscrollable.
  Both bindings tore the widget down with `inst.hide(); inst.dispose();`
  in the same tick, but `hide()` is transition based: the synchronous
  `dispose()` aborted Bootstrap’s teardown, so the backdrop node was
  removed while `body.modal-open` and the inline
  `overflow: hidden; padding-right: …` scroll lock stayed behind. Any
  overlay living inside a
  [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) froze the
  page as soon as it was re-rendered while shown. Disposal now waits for
  `hidden.bs.modal` / `hidden.bs.offcanvas` (Bootstrap fires it on a
  timeout even for a detached element), and a safety net drops the body
  scroll lock once nothing is shown.

- [`bootstrict_theme()`](https://thinkr-open.github.io/bootstrict/reference/bootstrict_theme.md)
  now puts each value in the Sass layer that can compile it, instead of
  handing everything to
  [`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
  as a named argument. Two forms used to fail outright: a theme colour
  defined from another variable — the way Bootstrap ships its own
  defaults — (`bootstrict_theme(secondary = "$gray-600")`) aborted on
  bslib’s HTML-colour validation, and any value derived from a Bootstrap
  variable (`"link-hover-color" = "shade-color($primary, 20%)"`) aborted
  at compile time with `Undefined variable: "$primary"`, because named
  arguments land in the *defaults* layer, which is emitted before
  Bootstrap’s own variables.

  Values built from literals or from the sheet’s own variables now go to
  the defaults layer, in sheet order, so `$primary: $brand-orange` works
  and still feeds `$theme-colors`; values referring to one of
  Bootstrap’s variables go to the *declarations* layer, where those
  exist. `bs_theme()` keeps the arguments that are not Sass variables
  (`bg`, `fg`, the fonts, `preset`, `bootswatch`). A theme colour
  redefined from one of Bootstrap’s own variables now compiles but lands
  after `$theme-colors` is built, so it does not restyle
  `.btn-secondary`; this is documented on
  [`bootstrict_theme()`](https://thinkr-open.github.io/bootstrict/reference/bootstrict_theme.md).

- [`parse_scss_variables()`](https://thinkr-open.github.io/bootstrict/reference/parse_scss_variables.md)
  no longer drops most of a designer’s sheet. It matched `$name: value;`
  line by line, so any declaration spanning several lines matched
  nothing and was discarded without a warning — that is the shape of
  every Bootstrap map (`$theme-colors`, `$grid-breakpoints`, `$spacers`,
  `$container-max-widths`, `$font-sizes`, `$utilities`). On Bootstrap’s
  own `_variables.scss` it read 916 of 963 declarations and
  `theme-colors` was absent. Stripping `//` comments with no notion of
  strings also truncated any value containing one, silently losing
  `$web-font-path` and `url("https://…")`; a `;` inside a quoted string
  cut the value short; and a final declaration with no trailing `;` was
  lost.

  The file is now scanned instead of split into lines: declarations may
  span any number of lines, `;` / `//` / `/* */` inside a quoted string
  or an unquoted [`url()`](https://rdrr.io/r/base/connections.html) are
  read as data, `#{}` interpolation is not mistaken for a rule block,
  and a rule block no longer bleeds into the declaration that follows
  it.

- [`bs_tooltip()`](https://thinkr-open.github.io/bootstrict/reference/bs_tooltip.md)
  /
  [`bs_popover()`](https://thinkr-open.github.io/bootstrict/reference/bs_popover.md)
  no longer disable the Shiny input they decorate. Both were initialised
  through a `Shiny.InputBinding`, and since Shiny binds at most one
  input per element and later registrations take precedence, the
  bootstrict binding claimed the element and the real one never bound:
  `bs_tooltip(bs_button("save", "Save"), "Ctrl+S")` left `input$save`
  permanently `NULL`. Tooltips and popovers are now initialised from the
  DOM (an initial sweep plus a `MutationObserver`, so
  [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) /
  [`insertUI()`](https://rdrr.io/pkg/shiny/man/insertUI.html) content is
  still covered) and disposed when their element is removed.

- [`bs_tooltip()`](https://thinkr-open.github.io/bootstrict/reference/bs_tooltip.md)
  /
  [`bs_popover()`](https://thinkr-open.github.io/bootstrict/reference/bs_popover.md)
  no longer break the tag they decorate when it is already a data-API
  trigger
  ([`bs_modal_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal_trigger.md),
  [`bs_offcanvas_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas_trigger.md),
  [`bs_collapse_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse_trigger.md),
  a dropdown toggle…). They used to append a second `data-bs-toggle`
  value (e.g. `"offcanvas tooltip"`), which Bootstrap’s exact
  `[data-bs-toggle="offcanvas"]` delegated selector no longer matched —
  the trigger went dead. The existing attribute is now left untouched;
  tooltip and popover initialisation never relied on it (it is driven by
  `data-bootstrict-tip`).

- Named arguments in `...` are now applied to the documented element:
  the
  [`bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md)
  wrapper (they were rendered as visible page text), the
  [`bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal.md)
  root (they landed on `.modal-body`), and the
  [`bs_navbar()`](https://thinkr-open.github.io/bootstrict/reference/bs_navbar.md)
  `<nav>` (they landed on the collapse `<div>`).

- Extra attributes passed to
  [`bs_checkbox_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_checkbox_input.md)
  /
  [`bs_switch_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_checkbox_input.md)
  are no longer silently dropped, and
  [`bs_file_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_file_input.md)’s
  `...` now lands on the real `<input type="file">` instead of the
  readonly display box (internal `has_class()` only saw the first of
  several `class` attribute entries).

- Attributes passed through `...` now *replace* a same-named attribute
  set by shiny instead of merging with it
  (`bs_text_input("x", type = "email")` no longer renders the invalid
  `type="text email"`).

- First server-driven update on a never-toggled collapse/accordion panel
  no longer does the opposite of what was asked: Bootstrap Collapse
  instances are now created with `{toggle: false}` (the constructor
  default `toggle: true` toggled the panel before the requested action
  ran).

- Responsive offcanvas (`bs_offcanvas(responsive =)`) now binds its
  state input: the JS selector matched `.offcanvas` only, never
  `.offcanvas-{bp}`, so `input$id` was never registered. Above the
  breakpoint the inline-shown panel now reports `TRUE`.

- `bs_carousel(autoplay = FALSE)` now omits `data-bs-ride` entirely; it
  used to emit `data-bs-ride="true"`, which resumes autoplay after the
  first user interaction.

- `update_bs_list_group(id, selected = NULL)` is now the documented
  no-op; it used to clear the whole selection and reset `input$id`. A
  `selected` value matching no item warns and leaves the selection
  unchanged.

- [`update_bs_accordion()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_accordion.md):
  `open = TRUE` now opens all panels (it used to send the literal string
  `"TRUE"`); `open`/`close = FALSE` are no-ops.

- `bs_button(href =, disabled = TRUE)` now renders the `.disabled` class
  and `tabindex="-1"` (the anchor was still clickable).

- Accordion state no longer leaks between nested accordions (panel
  discovery and Bootstrap events are now scoped to the accordion’s own
  panels), and an accordion with every panel closed reports `NULL`
  instead of [`list()`](https://rdrr.io/r/base/list.html).

- Progress: percentages are clamped to 0-100 as documented; a
  min/max-only update recomputes the width; a colour update no longer
  strips `bg-opacity-*` / `bg-gradient` classes (see also the Bootstrap
  5.3 markup restructure above).

- Ids containing CSS-special characters (e.g. dotted module namespaces)
  no longer break declarative wiring: every generated `data-bs-target` /
  `data-bs-parent` / trigger `href` selector is now CSS-escaped.

- Dynamic UI lifecycle: Bootstrap instances are disposed when Shiny
  unbinds a widget (modals/offcanvas hide first — no more stuck
  backdrops after a
  [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html)
  re-render),
  [`bs_notify_toast()`](https://thinkr-open.github.io/bootstrict/reference/bs_notify_toast.md)
  disposes each toast on hide (it leaked a detached DOM node and
  instance per notification), the list-group click handler unbinds
  cleanly (it used to stack up across unbind/rebind cycles),
  tooltip/popover auto-ids no longer collide (a shared timestamp gave
  duplicate ids) and their instances are disposed on unbind, and
  carousels/scrollspys inserted via
  [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) are now
  initialised at bind time (Bootstrap only scans on page load).

- [`bs_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_range_input.md)
  dragging is debounced as documented (`input` events now route through
  the rate policy; `change` still submits immediately), and the
  range/color JS selectors are scoped to bootstrict’s own
  `data-bootstrict` marker so hand-written Bootstrap markup is not
  hijacked.

- [`bs_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_range_input.md)
  and
  [`bs_color_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_color_input.md)
  participate in Shiny bookmarking
  ([`restoreInput()`](https://rdrr.io/pkg/shiny/man/restoreInput.html)).

- [`parse_scss_variables()`](https://thinkr-open.github.io/bootstrict/reference/parse_scss_variables.md)
  strips multi-line `/* ... */` comments (variables inside a commented
  block were parsed as real) and reads every declaration on a line, not
  just the first.

- [`use_bootstrict_golem()`](https://thinkr-open.github.io/bootstrict/reference/use_bootstrict_golem.md)
  scaffolds `_variables.scss` (SCSS syntax, which
  [`parse_scss_variables()`](https://thinkr-open.github.io/bootstrict/reference/parse_scss_variables.md)
  reads) instead of `_variables.sass` (indented syntax, which silently
  parsed to nothing).

- Radio/checkbox group labels get `.form-label`, per-option and single
  checkbox labels get `.form-check-label`, and
  [`bs_file_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_file_input.md)
  drops the leftover Bootstrap 3/4 markup (`.input-group-btn` wrapper,
  BS3 progress animation classes).

- Selectable / action list groups no longer emit invalid HTML (`<li>`
  items inside their `<div>` container are converted to `<div>`s);
  disabled anchor items get `tabindex="-1"`.

- Modals and offcanvas with a `title` now wire `aria-labelledby` to the
  title element; vertical tabsets set `aria-orientation="vertical"`;
  [`bs_collapse_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse_trigger.md)
  gains `expanded` for a correct initial `aria-expanded`/`.collapsed`
  state; `bs_breadcrumb(divider =)` escapes quotes/backslashes.

- Responsive `bs_dropdown(align = list(...))` now sets
  `data-bs-display="static"` on the toggle, without which Bootstrap
  ignores the responsive alignment classes.

### New features

- `update_bs_list_group(id, selected = character(0))` clears the
  selection (deselects every item and resets `input$id` to `NULL`).
  `selected = NULL` remains the no-op that leaves the current selection
  untouched, so a group can now be cleared server-side without the
  surprise reset that the pre-`NULL` no-op behaviour carried.
- [`bs_checkbox_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_checkbox_input.md),
  [`bs_switch_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_checkbox_input.md),
  [`bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_input.md)
  and
  [`bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_range_input.md)
  gain the `help` argument the other inputs already had.
- [`bs_notify_toast()`](https://thinkr-open.github.io/bootstrict/reference/bs_notify_toast.md)
  gains `autohide` (use `FALSE` for a persistent notification);
  header-less notifications now include a close button (they were
  undismissable), dark-background notifications get the dark-context
  close button (`data-bs-theme="dark"`), and the auto-created container
  is an `aria-live` region.
- [`bs_scrollspy()`](https://thinkr-open.github.io/bootstrict/reference/bs_scrollspy.md)
  gains an `id` (auto-generated by default) and reports the active
  section’s link as `input$id`.
- [`bs_offcanvas_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_offcanvas_trigger.md)
  delegates to
  [`bs_button()`](https://thinkr-open.github.io/bootstrict/reference/bs_button.md)
  like
  [`bs_modal_trigger()`](https://thinkr-open.github.io/bootstrict/reference/bs_modal_trigger.md)
  (it was a bare unstyled `.btn`).
- Server messages targeting a missing element now `console.warn` with
  the offending id instead of failing silently (the most common module
  namespacing mistake becomes visible).
- [`bootstrict_dep()`](https://thinkr-open.github.io/bootstrict/reference/bootstrict_dep.md)
  is built once per session and cached.

## bootstrict 0.0.0.9000

- Initial development version.
