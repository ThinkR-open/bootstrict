# bootstrict (development version)

## Bootstrap upgrade

The package now targets **Bootstrap 5.3** (5.3.8, the runtime `bslib` actually
ships) instead of 5.2, resolving the former 5.2-markup / 5.3-runtime split.

* Colour modes: `bs_page()` / `bs_page_fluid()` / `bs_page_fillable()` gain
  `color_mode` (initial `data-bs-theme` on the page body) and the new
  `set_bs_color_mode()` switches it from the server. The dark variants of
  navbar (`theme = "dark"`), dropdown and carousel (`dark = TRUE`) and the
  close button (`white = TRUE`) now emit `data-bs-theme="dark"` — their
  5.2-era classes (`.navbar-dark`, `.dropdown-menu-dark`, `.carousel-dark`,
  `.btn-close-white`) are deprecated in 5.3.
* Progress uses the 5.3 markup: `role="progressbar"` and the `aria-value*`
  attributes live on the `.progress` track (which now carries the `id`), the
  inner `.progress-bar` is purely visual, and passing several bars to
  `bs_progress()` renders a `.progress-stacked` group. `bs_progress_bar()`
  gains `aria_label`.
* New 5.3 surface: `bs_nav()` / `bs_tabset()` accept `type = "underline"`,
  `bs_img()` gains `object_fit` (`.object-fit-*`), `bs_icon_link()` renders
  the icon-link helper, and `bs_navbar(bg =)` accepts `"body"`,
  `"body-secondary"`, `"body-tertiary"`, `"white"`, `"black"`,
  `"transparent"`.
* 5.3 reference markup details: `bs_card_subtitle()` uses
  `text-body-secondary` (`.text-muted` is deprecated), `bs_modal_title()` is
  an `<h1 class="modal-title fs-5">` again, tab panes carry `tabindex="0"`,
  tooltips/popovers use `data-bs-title` (no more native-tooltip flash), and
  `help =` text is wired to its control via `aria-describedby`.

## Breaking changes

* `bs_page_fillable()` loses its `fillable` argument: `bslib::page_fillable()`
  has no such parameter, so the value leaked into the page markup as an
  invalid `fillable` HTML attribute and controlled nothing.
* `bs_modal(backdrop = FALSE)` now renders a modal with *no* backdrop
  (`data-bs-backdrop="false"`), matching Bootstrap and `bs_offcanvas()`.
  Use `backdrop = "static"` for a backdrop that does not dismiss on outside
  click (the previous behaviour of `FALSE`).
* `bs_input_group()` and `bs_floating_label()` now raise an error when given
  an input whose Shiny binding lives on its container (`bs_date_input()`,
  `bs_date_range_input()`, `bs_file_input()`, `bs_radio_input()`,
  `bs_checkbox_group_input()`). Previously they silently emitted a dead
  control with no id, binding, or dependencies.
* Layout constructors now validate their scales instead of emitting
  non-existent classes: `bs_col()` spans (1-12, `"auto"`, `TRUE`),
  `bs_row(cols=)` (1-6, `"auto"`), gutters and stack `gap` (0-5), `offset`
  (0-11), `order` (0-5, `"first"`, `"last"`), heading `level`s (1-6),
  `bs_pagination_numbered(current=)` (1..n), `bs_color_input(value=)`
  (`#rrggbb`), and `bs_tabset(selected=)` must match a panel value.
* `bs_notify_toast()` requires plain-text `body`/`title` (they are rendered
  via `textContent`; tags now raise an error instead of displaying raw markup
  or `[object Object]`), and its `...` must be empty.

## Bug fixes

* Named arguments in `...` are now applied to the documented element:
  the `bs_dropdown()` wrapper (they were rendered as visible page text), the
  `bs_modal()` root (they landed on `.modal-body`), and the `bs_navbar()`
  `<nav>` (they landed on the collapse `<div>`).
* Extra attributes passed to `bs_checkbox_input()` / `bs_switch_input()` are
  no longer silently dropped, and `bs_file_input()`'s `...` now lands on the
  real `<input type="file">` instead of the readonly display box (internal
  `has_class()` only saw the first of several `class` attribute entries).
* Attributes passed through `...` now *replace* a same-named attribute set by
  shiny instead of merging with it (`bs_text_input("x", type = "email")` no
  longer renders the invalid `type="text email"`).
* First server-driven update on a never-toggled collapse/accordion panel no
  longer does the opposite of what was asked: Bootstrap Collapse instances are
  now created with `{toggle: false}` (the constructor default `toggle: true`
  toggled the panel before the requested action ran).
* Responsive offcanvas (`bs_offcanvas(responsive =)`) now binds its state
  input: the JS selector matched `.offcanvas` only, never `.offcanvas-{bp}`,
  so `input$id` was never registered. Above the breakpoint the inline-shown
  panel now reports `TRUE`.
* `bs_carousel(autoplay = FALSE)` now omits `data-bs-ride` entirely; it used
  to emit `data-bs-ride="true"`, which resumes autoplay after the first user
  interaction.
* `update_bs_list_group(id, selected = NULL)` is now the documented no-op; it
  used to clear the whole selection and reset `input$id`. A `selected` value
  matching no item warns and leaves the selection unchanged.
* `update_bs_accordion()`: `open = TRUE` now opens all panels (it used to
  send the literal string `"TRUE"`); `open`/`close = FALSE` are no-ops.
* `bs_button(href =, disabled = TRUE)` now renders the `.disabled` class and
  `tabindex="-1"` (the anchor was still clickable).
* Accordion state no longer leaks between nested accordions (panel discovery
  and Bootstrap events are now scoped to the accordion's own panels), and an
  accordion with every panel closed reports `NULL` instead of `list()`.
* Progress: percentages are clamped to 0-100 as documented; a min/max-only
  update recomputes the width; a colour update no longer strips
  `bg-opacity-*` / `bg-gradient` classes (see also the Bootstrap 5.3 markup
  restructure above).
* Ids containing CSS-special characters (e.g. dotted module namespaces) no
  longer break declarative wiring: every generated `data-bs-target` /
  `data-bs-parent` / trigger `href` selector is now CSS-escaped.
* Dynamic UI lifecycle: Bootstrap instances are disposed when Shiny unbinds a
  widget (modals/offcanvas hide first — no more stuck backdrops after a
  `renderUI()` re-render), `bs_notify_toast()` disposes each toast on hide
  (it leaked a detached DOM node and instance per notification), the
  list-group click handler unbinds cleanly (it used to stack up across
  unbind/rebind cycles), tooltip/popover auto-ids no longer collide (a shared
  timestamp gave duplicate ids) and their instances are disposed on unbind,
  and carousels/scrollspys inserted via `renderUI()` are now initialised at
  bind time (Bootstrap only scans on page load).
* `bs_range_input()` dragging is debounced as documented (`input` events now
  route through the rate policy; `change` still submits immediately), and the
  range/color JS selectors are scoped to bootstrict's own `data-bootstrict`
  marker so hand-written Bootstrap markup is not hijacked.
* `bs_range_input()` and `bs_color_input()` participate in Shiny bookmarking
  (`restoreInput()`).
* `parse_scss_variables()` strips multi-line `/* ... */` comments (variables
  inside a commented block were parsed as real) and reads every declaration
  on a line, not just the first.
* `use_bootstrict_golem()` scaffolds `_variables.scss` (SCSS syntax, which
  `parse_scss_variables()` reads) instead of `_variables.sass` (indented
  syntax, which silently parsed to nothing).
* Radio/checkbox group labels get `.form-label`, per-option and single
  checkbox labels get `.form-check-label`, and `bs_file_input()` drops the
  leftover Bootstrap 3/4 markup (`.input-group-btn` wrapper, BS3 progress
  animation classes).
* Selectable / action list groups no longer emit invalid HTML (`<li>` items
  inside their `<div>` container are converted to `<div>`s); disabled anchor
  items get `tabindex="-1"`.
* Modals and offcanvas with a `title` now wire `aria-labelledby` to the title
  element; vertical tabsets set `aria-orientation="vertical"`;
  `bs_collapse_trigger()` gains `expanded` for a correct initial
  `aria-expanded`/`.collapsed` state; `bs_breadcrumb(divider =)` escapes
  quotes/backslashes.
* Responsive `bs_dropdown(align = list(...))` now sets
  `data-bs-display="static"` on the toggle, without which Bootstrap ignores
  the responsive alignment classes.

## New features

* `bs_checkbox_input()`, `bs_switch_input()`, `bs_date_input()` and
  `bs_date_range_input()` gain the `help` argument the other inputs already
  had.
* `bs_notify_toast()` gains `autohide` (use `FALSE` for a persistent
  notification); header-less notifications now include a close button (they
  were undismissable), dark-background notifications get the dark-context
  close button (`data-bs-theme="dark"`), and the auto-created container is
  an `aria-live` region.
* `bs_scrollspy()` gains an `id` (auto-generated by default) and reports the
  active section's link as `input$id`.
* `bs_offcanvas_trigger()` delegates to `bs_button()` like
  `bs_modal_trigger()` (it was a bare unstyled `.btn`).
* Server messages targeting a missing element now `console.warn` with the
  offending id instead of failing silently (the most common module
  namespacing mistake becomes visible).
* `bootstrict_dep()` is built once per session and cached.

# bootstrict 0.0.0.9000

* Initial development version.
