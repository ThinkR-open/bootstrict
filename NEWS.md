# bootstrict (development version)

## New widgets

* `bs_feedback()` and `set_bs_validation()` make validation feedback work.
  Bootstrap only displays a `.valid-feedback` / `.invalid-feedback` message
  when it is a *following sibling* of the control carrying `.is-valid` /
  `.is-invalid`. Every `bs_*_input()` returns its control wrapped in shiny's
  `div.form-group.shiny-input-container`, so a `bs_invalid_feedback()` placed
  after the input was a sibling of the *wrapper*, never of the control, and
  stayed `display: none` — the pattern the forms vignette and the demo app
  both showed could not work. `bs_feedback(input, valid =, invalid =)` inserts
  the messages next to the control itself (once after the last option, for a
  choice group), takes an optional initial `state =`, and
  `set_bs_validation(id, state, message)` switches the state and the message
  text from the server.

* `bs_download_button()` and `bs_download_link()` wrap
  `shiny::downloadButton()` / `shiny::downloadLink()`. shiny hardcodes the
  Bootstrap 3 class `.btn-default` on the download button, which has no
  Bootstrap 5 equivalent and leaves the button unstyled; the wrapper swaps it
  for a real 5.3 variant and takes `color` / `outline` / `size` like
  `bs_button()`. shiny's download plumbing (the `shiny-download-link` class,
  `href` / `target` / `download` and the auto-enable dance) is left intact, so
  the server side stays a plain `shiny::downloadHandler()`. `icon` defaults to
  `NULL` rather than shiny's Font Awesome icon, which is outside Bootstrap 5.

## New showcase app

* `inst/examples/quakewatch`: Quake Watch, a realistic demo (a seismic monitor
  for the Fiji region built on `datasets::quakes`) complementing the exhaustive
  widget catalogue in `inst/examples/demo`. It exercises the designer hand-off
  (`bootstrict_theme(variables = "_variables.scss")`), UI-declared overlays
  (offcanvas filter drawer, modal event records, toasts), state-reporting
  components driven by `update_bs_*()`, and the 5.3 surface (colour modes,
  `.nav-underline`, `.progress-stacked`). Run it with
  `shiny::runApp(system.file("examples/quakewatch", package = "bootstrict"))`.

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

* The close button of a responsive `bs_offcanvas()` now closes it. A
  responsive panel carries `.offcanvas-{bp}` *instead of* `.offcanvas`, and
  Bootstrap's dismiss handler resolves its target as
  `getElementFromSelector(this) || this.closest(".offcanvas")`: with no
  explicit target it found nothing, threw
  `TypeError: Cannot read properties of undefined (reading 'backdrop')` and
  left the panel open. The header close button now carries an explicit
  `data-bs-target` (escaped, so module ids work), which is harmless on a plain
  offcanvas since it resolves to the same element.


* A hand-composed `bs_modal()` no longer nests its header and footer inside a
  `.modal-body`. `bs_modal()`'s own documentation invites composing the dialog
  with `bs_modal_header()` / `bs_modal_body()` / `bs_modal_footer()`, but every
  unnamed child was wrapped in a `.modal-body` regardless, so the documented
  path produced `.modal-content > .modal-body > (.modal-header, .modal-body,
  .modal-footer)` — invalid structure that breaks the sticky header and the
  scrollable body. Children that already carry one of those classes are now
  emitted as siblings of `.modal-content`; bare children are still wrapped, in
  place, so the two styles can be mixed.


* Re-rendering a `bs_modal()` or `bs_offcanvas()` while it is open no longer
  leaves the page permanently unscrollable. Both bindings tore the widget down
  with `inst.hide(); inst.dispose();` in the same tick, but `hide()` is
  transition based: the synchronous `dispose()` aborted Bootstrap's teardown,
  so the backdrop node was removed while `body.modal-open` and the inline
  `overflow: hidden; padding-right: …` scroll lock stayed behind. Any overlay
  living inside a `renderUI()` froze the page as soon as it was re-rendered
  while shown. Disposal now waits for `hidden.bs.modal` /
  `hidden.bs.offcanvas` (Bootstrap fires it on a timeout even for a detached
  element), and a safety net drops the body scroll lock once nothing is shown.


* `bootstrict_theme()` now puts each value in the Sass layer that can compile
  it, instead of handing everything to `bslib::bs_theme()` as a named
  argument. Two forms used to fail outright: a theme colour defined from
  another variable — the way Bootstrap ships its own defaults —
  (`bootstrict_theme(secondary = "$gray-600")`) aborted on bslib's HTML-colour
  validation, and any value derived from a Bootstrap variable
  (`"link-hover-color" = "shade-color($primary, 20%)"`) aborted at compile
  time with `Undefined variable: "$primary"`, because named arguments land in
  the *defaults* layer, which is emitted before Bootstrap's own variables.

  Values built from literals or from the sheet's own variables now go to the
  defaults layer, in sheet order, so `$primary: $brand-orange` works and still
  feeds `$theme-colors`; values referring to one of Bootstrap's variables go to
  the *declarations* layer, where those exist. `bs_theme()` keeps the arguments
  that are not Sass variables (`bg`, `fg`, the fonts, `preset`, `bootswatch`).
  A theme colour redefined from one of Bootstrap's own variables now compiles
  but lands after `$theme-colors` is built, so it does not restyle
  `.btn-secondary`; this is documented on `bootstrict_theme()`.


* `parse_scss_variables()` no longer drops most of a designer's sheet. It
  matched `$name: value;` line by line, so any declaration spanning several
  lines matched nothing and was discarded without a warning — that is the
  shape of every Bootstrap map (`$theme-colors`, `$grid-breakpoints`,
  `$spacers`, `$container-max-widths`, `$font-sizes`, `$utilities`). On
  Bootstrap's own `_variables.scss` it read 916 of 963 declarations and
  `theme-colors` was absent. Stripping `//` comments with no notion of strings
  also truncated any value containing one, silently losing `$web-font-path`
  and `url("https://…")`; a `;` inside a quoted string cut the value short;
  and a final declaration with no trailing `;` was lost.

  The file is now scanned instead of split into lines: declarations may span
  any number of lines, `;` / `//` / `/* */` inside a quoted string or an
  unquoted `url()` are read as data, `#{}` interpolation is not mistaken for a
  rule block, and a rule block no longer bleeds into the declaration that
  follows it.


* `bs_tooltip()` / `bs_popover()` no longer disable the Shiny input they
  decorate. Both were initialised through a `Shiny.InputBinding`, and since
  Shiny binds at most one input per element and later registrations take
  precedence, the bootstrict binding claimed the element and the real one never
  bound: `bs_tooltip(bs_button("save", "Save"), "Ctrl+S")` left `input$save`
  permanently `NULL`. Tooltips and popovers are now initialised from the DOM
  (an initial sweep plus a `MutationObserver`, so `renderUI()` / `insertUI()`
  content is still covered) and disposed when their element is removed.

* `bs_tooltip()` / `bs_popover()` no longer break the tag they decorate when it
  is already a data-API trigger (`bs_modal_trigger()`, `bs_offcanvas_trigger()`,
  `bs_collapse_trigger()`, a dropdown toggle…). They used to append a second
  `data-bs-toggle` value (e.g. `"offcanvas tooltip"`), which Bootstrap's exact
  `[data-bs-toggle="offcanvas"]` delegated selector no longer matched — the
  trigger went dead. The existing attribute is now left untouched; tooltip and
  popover initialisation never relied on it (it is driven by
  `data-bootstrict-tip`).

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

* `update_bs_list_group(id, selected = character(0))` clears the selection
  (deselects every item and resets `input$id` to `NULL`). `selected = NULL`
  remains the no-op that leaves the current selection untouched, so a group
  can now be cleared server-side without the surprise reset that the pre-`NULL`
  no-op behaviour carried.
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
