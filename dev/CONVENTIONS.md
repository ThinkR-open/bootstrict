# bootstrict — implementation conventions

Read this before adding any component. The goal: a faithful, 1:1 Bootstrap 5
implementation as Shiny UI functions, with **minimum deviation from Shiny**.
The Bootstrap **5.3.8** runtime is provided by `bslib` and the designer
targets the Bootstrap **5.3** docs — use exactly the classes/markup documented
at <https://getbootstrap.com/docs/5.3>. This includes the 5.3 additions
(colour modes / `data-bs-theme`, `.nav-underline`, `.progress-stacked`,
`.object-fit-*`, focus-ring utilities, `.icon-link`) and the patterns 5.3
prescribes over their deprecated 5.2-era equivalents: `data-bs-theme="dark"`
instead of `.navbar-dark` / `.dropdown-menu-dark` / `.carousel-dark` /
`.btn-close-white`, `.text-body-secondary` instead of `.text-muted`, and
`data-bs-title` for tooltips/popovers.

## Naming & API

- Every public constructor is `snake_case`, prefixed `bs_` (e.g. `bs_badge()`).
- Interactive constructors take a **leading `id`** so the value is `input$id`.
- `...` follows the htmltools/Shiny convention: **named** args become HTML
  attributes, **unnamed** args become children. Always forward `...`.
- Every constructor takes a trailing `class = NULL` for extra classes.
- Booleans default to `FALSE`; enum-like args default to `NULL` (meaning "none")
  unless Bootstrap mandates a value.

## Shared helpers (in `R/utils.R` — read it, don't redefine)

- `bs_classes(...)` — assemble a class string; drops NULL/empty, de-dupes.
- `mod(prefix, value)` — `mod("btn", "primary")` -> `"btn-primary"`, NULL-safe.
- `match_arg(arg, values)` — validate an enum, allows NULL (returns NULL).
- `check_color(x)` — validate a theme colour against `bs_theme_colors`.
- `bs_theme_colors` = primary/secondary/success/danger/warning/info/light/dark.
- `bs_breakpoints` = sm/md/lg/xl/xxl.
- `responsive_classes(prefix, value)` — scalar or named per-breakpoint list.
- `tag_modify_where(x, predicate, fn)` — recurse a tag tree applying `fn`.
- `has_class(tag, cls)`, `enhance_form_control()`, `add_form_help()`,
  `add_control_attribs()` — form helpers.
- `attach_deps(tag)` — **call on the return value of every top-level public
  constructor** (not on sub-pieces like `bs_card_body()`), so the bootstrict
  dependency travels with the widget. Returns the same tag (composable).
- `%||%` is available (imported from rlang).

## Static components (no server state)

Build faithful Bootstrap markup with `htmltools` and wrap the top-level return
in `attach_deps()`. Pass a list of children directly (htmltools flattens lists);
do NOT use `!!!`. Example pattern: see `R/card.R`, `R/alert.R`.

## Form inputs

**Delegate to the matching `shiny::*Input()`** for the binding + `update*()`
semantics, then enhance:

```r
ctrl <- shiny::textInput(id, label, value, ...)
ctrl <- enhance_form_control(ctrl, size = size)   # adds .form-label, sizing
ctrl <- add_control_attribs(ctrl, ...)            # spreads extra attrs onto control
ctrl <- add_form_help(ctrl, help)                 # appends .form-text
attach_deps(ctrl)
```

Only build a control natively (with your own binding) when Shiny has no
equivalent (e.g. `<input type="range" class="form-range">`,
`<input type="color" class="form-control-color">`). See `R/forms.R`.

## Interactive components (report state to the server)

1. **Markup**: faithful Bootstrap 5 HTML. Put `id` on the root. Mark the root
   with `data-bootstrict = "<name>"` so the binding selects only our widgets
   (never bslib's). Give each reportable sub-element a `data-value`.
2. **Binding**: one file `inst/assets/js/binding-<name>.js`. Use the core
   factory — never hand-roll `Shiny.InputBinding` plumbing:
   ```js
   (function (window) { "use strict";
     var bootstrict = window.bootstrict; if (!bootstrict) return;
     bootstrict.eventBinding({
       name: "bootstrict.<name>",
       selector: ".<root>[data-bootstrict='<name>']",
       events: ["shown.bs.tab", "hidden.bs.tab"],   // bubbling Bootstrap events
       getValue: function (el) { /* read DOM -> value */ }
     });
   })(window);
   ```
   (The dependency auto-discovers any `.js` file in that dir; no registration.)
3. **Server control**: an `update_bs_<name>()`
   that calls `bs_send("<name>.<action>", id = bs_ns(id, session), ...)`. On the
   client register `bootstrict.addHandler("<name>.<action>", function (msg) {...})`
   in the same binding file. Use `bootstrict.bs("Modal", el)` to reach the
   Bootstrap JS instance. See `R/accordion.R` + `binding-accordion.js`.

Bootstrap events that bubble and are useful for bindings: `shown.bs.collapse`,
`hidden.bs.collapse`, `shown.bs.tab`, `hide.bs.tab`, `slid.bs.carousel`,
`shown.bs.offcanvas`, `hidden.bs.offcanvas`, `shown.bs.modal`, `hidden.bs.modal`,
`shown.bs.dropdown`, `hidden.bs.dropdown`.

Tooltips & popovers are NOT auto-initialised by Bootstrap — the binding/init JS
must `new bootstrap.Tooltip(el)` for each target.

## Files per component group

- `R/<group>.R` — the constructors + any `update_*()` (roxygen with `@export`,
  a one-line `@examples`).
- `inst/assets/js/binding-<name>.js` — only if interactive.
- `tests/testthat/test-<group>.R` — render the widget with
  `as.character(...)` and assert key classes/attributes/structure are present
  (use testthat 3e, `expect_match`/`expect_true`). Do NOT start a Shiny server.

## Hard rules

- Do **not** edit `NAMESPACE` (roxygen regenerates it) or any file you were not
  assigned. Do **not** modify `R/utils.R`, `R/deps.R`, `R/theme.R`,
  `inst/assets/js/bootstrict-core.js`.
- If you need a helper that doesn't exist, define it **privately in your own
  file** with a unique name; never touch shared files.
- Validate your R file parses (`parse("R/<group>.R")`). Do NOT run
  `pkgload::load_all()` (other files may be mid-write during parallel work).
