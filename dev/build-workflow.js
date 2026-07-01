export const meta = {
  name: 'bootstrict-inventory',
  description: 'Generate the full Bootstrap 5 component inventory for bootstrict',
  phases: [
    { title: 'Generate', detail: 'one agent per component group, in parallel' }
  ]
}

const ROOT = '/Users/colinfay/git/github/thinkr-open/bootstrict'

const PREAMBLE = `You are implementing ONE component group of the R package \`bootstrict\`
(a faithful Bootstrap 5 widget library for Shiny). Working directory: ${ROOT}.

STEP 1 — read these files to absorb the exact conventions and reference patterns
(use the Read tool):
  - dev/CONVENTIONS.md   (the contract — follow it precisely)
  - R/utils.R            (shared helpers you MUST reuse, never redefine)
  - R/card.R, R/alert.R  (static component patterns)
  - R/forms.R            (form input = delegate to shiny + enhance pattern)
  - R/accordion.R + inst/assets/js/binding-accordion.js  (interactive: markup + JS binding + update_*)
  - inst/assets/js/bootstrict-core.js  (the JS factory: bootstrict.eventBinding / bootstrict.addHandler / bootstrict.bs)

KEY RULES (also in CONVENTIONS.md):
  - Public constructors are snake_case, prefixed bs_, take trailing class = NULL, forward ... .
  - Named ... become HTML attributes, unnamed ... become children (htmltools convention).
  - Wrap the return of every TOP-LEVEL public constructor in attach_deps(); do NOT wrap sub-pieces.
  - Pass a list of children directly to htmltools tags (it flattens lists); never use !!! .
  - Reuse helpers from R/utils.R: bs_classes(), mod(), match_arg(), check_color(),
    bs_theme_colors, bs_breakpoints, responsive_classes(), tag_modify_where(), has_class(),
    enhance_form_control(), add_form_help(), add_control_attribs(), attach_deps(), %||% .
  - These already exist elsewhere in the package — USE them, do not redefine: bs_button() (R/buttons.R),
    bs_close_button() (R/alert.R), bs_nav_link()/bs_nav_item() (R/nav-tabs.R), bs_dropdown* (R/dropdown.R).
  - Form inputs: delegate to the matching shiny::*Input() then enhance_form_control()/add_form_help();
    only build natively (with your own JS binding) when shiny has no equivalent.
  - Interactive widgets: faithful BS5 markup with id on the root + data-bootstrict="<name>" on the root +
    data-value on reportable sub-elements; ONE binding file inst/assets/js/binding-<name>.js built with
    bootstrict.eventBinding({...}); server control via update_bs_<name>()/*_proxy() calling
    bs_send("<name>.<action>", id = bs_ns(id, session), ...) with a matching bootstrict.addHandler() in
    the same JS file. Reach the Bootstrap instance with bootstrict.bs("Modal", el) etc.
  - Bootstrap 5.0 docs only (https://getbootstrap.com/docs/5.0). Runtime is Bootstrap 5.3.8 via bslib.

STEP 2 — write ONLY the files listed in your task below. Full roxygen on every exported
function: @param for each arg, @return, @export, and a one-line runnable @examples. Add a
tests/testthat/<test file> using testthat 3e that renders each widget via as.character() and
asserts key classes / attributes / structure with expect_match()/expect_true() (do NOT start a
Shiny server, do NOT call load_all).

STEP 3 — verify your R file parses: run Bash \`cd ${ROOT} && Rscript -e 'invisible(parse("R/<your file>"))'\`
and fix any error until it exits cleanly. Do NOT run pkgload::load_all (other files are being written
concurrently). Do NOT edit NAMESPACE, R/utils.R, R/deps.R, R/theme.R, inst/assets/js/bootstrict-core.js,
or any file not assigned to you.

YOUR TASK:
`

const TASKS = [
  {
    key: 'content',
    label: 'content',
    spec: `Group "content" -> files: R/content.R, tests/testthat/test-content.R.
Implement (faithful BS5 markup):
- bs_table(data = NULL, ..., striped=FALSE, bordered=FALSE, borderless=FALSE, hover=FALSE,
  small=FALSE, variant=NULL, responsive=FALSE, align=NULL, caption=NULL, class=NULL):
  <table class="table table-striped table-bordered table-hover table-sm table-{variant} align-{align}">.
  If data is a data.frame/matrix build <thead><tr><th> from colnames and <tbody><tr><td> from rows;
  else treat ... as manual children. responsive=TRUE wraps in <div class="table-responsive">, a breakpoint
  string -> table-responsive-{bp}. caption -> <caption>. variant uses check_color(). attach_deps on the
  outermost element.
- bs_img(src, ..., fluid=FALSE, thumbnail=FALSE, rounded=FALSE, alt=NULL, class=NULL):
  <img class="img-fluid|img-thumbnail|rounded">. attach_deps.
- bs_figure(..., class=NULL) -> <figure class="figure">; bs_figure_img(src, ..., alt=NULL) ->
  <img class="figure-img img-fluid rounded">; bs_figure_caption(..., class=NULL) -> <figcaption class="figure-caption">.
- bs_blockquote(..., footer=NULL, class=NULL): <figure><blockquote class="blockquote">...</blockquote>
  <figcaption class="blockquote-footer">footer</figcaption></figure> (omit figcaption if footer NULL).
- bs_display_heading(..., level=1, class=NULL) -> <h{level} class="display-{level}">.
- bs_lead(..., class=NULL) -> <p class="lead">.
- bs_list_unstyled(..., class=NULL) -> <ul class="list-unstyled"> with each child wrapped in <li>;
  bs_list_inline(..., class=NULL) -> <ul class="list-inline"> with each child in <li class="list-inline-item">.`
  },
  {
    key: 'badge-breadcrumb',
    label: 'badge+breadcrumb',
    spec: `Group "badge-breadcrumb" -> files: R/badge-breadcrumb.R, tests/testthat/test-badge-breadcrumb.R.
- bs_badge(..., color="primary", pill=FALSE, class=NULL): <span class="badge text-bg-{color} rounded-pill?">.
  check_color(color). attach_deps.
- bs_breadcrumb(..., divider=NULL, label="breadcrumb", class=NULL): <nav aria-label={label}>
  <ol class="breadcrumb">items</ol></nav>; when divider is a string set style="--bs-breadcrumb-divider: '{divider}'"
  on the <nav>. attach_deps on <nav>.
- bs_breadcrumb_item(..., active=FALSE, href=NULL, class=NULL): <li class="breadcrumb-item active?"
  aria-current="page" if active>. If href and not active, wrap children in <a href>. Otherwise children inline.`
  },
  {
    key: 'spinner-placeholder',
    label: 'spinner+placeholder',
    spec: `Group "spinner-placeholder" -> files: R/spinner-placeholder.R, tests/testthat/test-spinner-placeholder.R.
- bs_spinner(type=c("border","grow"), color=NULL, size=NULL, label="Loading...", ..., class=NULL):
  <div class="spinner-border|spinner-grow text-{color} spinner-border-sm|spinner-grow-sm" role="status">
  <span class="visually-hidden">{label}</span></div>. size only accepts "sm". check_color(color). attach_deps.
- bs_placeholder(..., width=NULL, color=NULL, size=NULL, class=NULL): <span class="placeholder
  col-{width} bg-{color} placeholder-{size}"> (size in lg/sm/xs). width is an integer 1-12 column count.
- bs_placeholder_glow(..., class=NULL) -> <p class="placeholder-glow">; bs_placeholder_wave(...) -> <p class="placeholder-wave">.
  attach_deps on the glow/wave wrappers and on standalone bs_placeholder.`
  },
  {
    key: 'pagination',
    label: 'pagination',
    spec: `Group "pagination" -> files: R/pagination.R, tests/testthat/test-pagination.R.
- bs_pagination(..., size=NULL, align=NULL, label="Page navigation", class=NULL):
  <nav aria-label={label}><ul class="pagination pagination-{sm|lg} justify-content-{start|center|end}">items</ul></nav>.
  align maps to justify-content-*. attach_deps on <nav>.
- bs_page_item(..., href="#", active=FALSE, disabled=FALSE, class=NULL):
  <li class="page-item active? disabled?"><a class="page-link" href {aria-current="page" if active}
  {tabindex="-1" aria-disabled="true" if disabled}>children</a></li>.
- bs_pagination_numbered(n, current=1, ..., href_template=NULL, size=NULL, align=NULL): convenience that builds
  prev + 1..n page items (current one active) + next using bs_page_item; href "#" by default.`
  },
  {
    key: 'progress',
    label: 'progress',
    spec: `Group "progress" -> files: R/progress.R, inst/assets/js/binding-progress.js, tests/testthat/test-progress.R.
Progress is NOT a Shiny input (no value reported); it is server-updatable only.
- bs_progress(..., height=NULL, class=NULL): <div class="progress" role="progressbar"> wrapping one or more
  bs_progress_bar(); height -> style="height: {height}". (For BS 5.0 markup keep role/aria on the inner bar too.) attach_deps.
- bs_progress_bar(value=0, ..., min=0, max=100, color=NULL, striped=FALSE, animated=FALSE, label=NULL,
  id=NULL, class=NULL): <div id class="progress-bar bg-{color} progress-bar-striped progress-bar-animated"
  role="progressbar" style="width: {pct}%" aria-valuenow={value} aria-valuemin={min} aria-valuemax={max}>{label}</div>
  where pct = round(100*(value-min)/(max-min)). check_color(color).
- update_bs_progress(id, value=NULL, label=NULL, color=NULL, min=NULL, max=NULL,
  session=shiny::getDefaultReactiveDomain()): bs_send("progress.update", id=bs_ns(id,session), value, label, color, min, max).
binding-progress.js: bootstrict.addHandler("progress.update", msg => find #id, set style.width = pct%,
set aria-valuenow, replace text if label given, swap bg-* class if color given). Recompute pct from value/min/max
(default min 0 max 100). No eventBinding needed.`
  },
  {
    key: 'list-group',
    label: 'list-group',
    spec: `Group "list-group" -> files: R/list-group.R, inst/assets/js/binding-list-group.js, tests/testthat/test-list-group.R.
- bs_list_group(id=NULL, ..., flush=FALSE, numbered=FALSE, horizontal=FALSE, class=NULL):
  container class "list-group list-group-flush? list-group-numbered? list-group-horizontal?"
  (horizontal=TRUE -> list-group-horizontal, a breakpoint string -> list-group-horizontal-{bp}).
  Choose the container tag: if numbered -> <ol>; else if any child tag name is "a" or "button" OR id is set -> <div>;
  else <ul>. If id is set add id + data-bootstrict="list-group" (selectable). attach_deps.
- bs_list_group_item(..., value=NULL, active=FALSE, disabled=FALSE, color=NULL, action=FALSE, href=NULL, class=NULL):
  base class "list-group-item list-group-item-action? list-group-item-{color}? active? disabled?".
  If href -> <a href class=... data-value=value? {aria-current="true" if active}>; else if action -> <button type="button" class=... data-value>;
  else <li class="list-group-item ...">. Add data-value=value when value not NULL (for selectable groups).
Selectable behaviour: when the parent group has id, clicking an action item reports its data-value as input$id.
binding-list-group.js: eventBinding name "bootstrict.listgroup", selector ".list-group[data-bootstrict='list-group']",
getValue = data-value of the .active item (or null). Use opts.subscribe to delegate click on
".list-group-item-action" -> set active class (remove from siblings), call callback. Add
bootstrict.addHandler("listgroup.update", msg => activate item by data-value). Also export
update_bs_list_group(id, selected=NULL, session=...) -> bs_send("listgroup.update", id=bs_ns(id), selected).`
  },
  {
    key: 'forms-controls',
    label: 'forms-controls',
    spec: `Group "forms-controls" -> files: R/forms-controls.R, inst/assets/js/binding-range.js,
inst/assets/js/binding-color.js, tests/testthat/test-forms-controls.R.
DELEGATE to shiny where possible then enhance to BS5 form-check markup with tag_modify_where()/has_class():
- bs_radio_input(id, label=NULL, choices, selected=NULL, ..., inline=FALSE, help=NULL, width=NULL):
  ctrl <- shiny::radioButtons(id,label,choices,selected,inline=inline,width=width); then convert each
  ".radio"/".radio-inline" wrapper to "form-check form-check-inline?", each radio <input> add "form-check-input",
  each label add "form-check-label". add_form_help. attach_deps. (shiny's radiogroup binding keeps input$id working.)
- bs_checkbox_group_input(id, label=NULL, choices, selected=NULL, ..., inline=FALSE, help=NULL, width=NULL):
  same approach via shiny::checkboxGroupInput; convert ".checkbox" -> "form-check", inputs -> "form-check-input",
  labels -> "form-check-label".
- bs_range_input(id, label=NULL, value=NULL, min=0, max=100, step=NULL, ..., help=NULL, width=NULL):
  NATIVE markup: <div class="shiny-input-container form-group" style="width:{width}"> <label class="form-label" for=id id="{id}-label">label</label>
  <input id type="range" class="form-range" min max step value data-bootstrict="range"></div>. add_form_help. attach_deps.
- bs_color_input(id, label=NULL, value="#000000", ..., help=NULL, width=NULL):
  NATIVE: same container, <input id type="color" class="form-control form-control-color" value data-bootstrict="color">.
- bs_file_input(id, label=NULL, ..., multiple=FALSE, accept=NULL, button_label="Browse...",
  placeholder="No file selected", width=NULL): shiny::fileInput(...) then add class "form-control" to the file <input>.
- bs_date_input(id, label=NULL, value=NULL, ..., min=NULL, max=NULL, width=NULL): shiny::dateInput(...) then
  enhance_form_control() (the .form-control date input).
- bs_date_range_input(id, label=NULL, start=NULL, end=NULL, ..., min=NULL, max=NULL, width=NULL): shiny::dateRangeInput then enhance.
binding-range.js: eventBinding name "bootstrict.range", selector "input[type='range'].form-range",
getValue = Number(el.value), subscribe on "input change" (use opts.events ["input","change"]),
receiveMessage(el,data){ if(data.value!=null) el.value=data.value; } and a getRatePolicy via ratePolicy {policy:'debounce',delay:250}.
Also export update_bs_range(id, value, session=...) -> bs_send("range.update", id=bs_ns(id), value) AND add a
bootstrict.addHandler("range.update", ...) that sets value + dispatches a change. Actually simpler: implement
update via receiveMessage (Shiny update path) — register the input value setter through Shiny by exporting
update_bs_range(id, value, ...) using shiny::session$sendInputMessage(id, list(value=value)). Prefer
session$sendInputMessage so the binding's receiveMessage handles it (more "shiny-like"). Same for binding-color.js
(name "bootstrict.color", selector "input[type='color'].form-control-color", getValue=el.value, events ["input","change"],
receiveMessage sets el.value) and update_bs_color(id, value, ...) via session$sendInputMessage.`
  },
  {
    key: 'forms-layout',
    label: 'forms-layout',
    spec: `Group "forms-layout" -> files: R/forms-layout.R, tests/testthat/test-forms-layout.R. (No JS.)
- bs_input_group(..., size=NULL, class=NULL): <div class="input-group input-group-{sm|lg}?">children</div>. attach_deps.
- bs_input_group_text(..., class=NULL): <span class="input-group-text">.
- bs_form(..., novalidate=FALSE, class=NULL): <form class="..." {novalidate}>children</form>. attach_deps.
- bs_form_label(for_id, ..., class=NULL): <label class="form-label" for={for_id}>.
- bs_form_text(..., class=NULL): <div class="form-text">.
- bs_valid_feedback(..., class=NULL): <div class="valid-feedback">; bs_invalid_feedback(...): <div class="invalid-feedback">.
- bs_floating_label(input, label=NULL, class=NULL): take an input built by bs_text_input()/bs_select_input()/etc
  (a tag tree) and reshape it into a Bootstrap floating-label group: locate the inner .form-control/.form-select
  element (use tag_modify_where/has_class) and the existing label; return
  <div class="form-floating">{the control}{<label for=...>label</label>}</div> with the control kept (give it a
  placeholder=" " if it has none, required for floating) and the label AFTER the control. If label is NULL reuse the
  control's existing label text. Preserve the control's id and shiny-input wiring (do not rebuild the <input> from
  scratch — move the existing element). attach_deps on the returned wrapper.`
  },
  {
    key: 'nav-tabs',
    label: 'nav+tabs',
    spec: `Group "nav-tabs" -> files: R/nav-tabs.R, inst/assets/js/binding-tabset.js, tests/testthat/test-nav-tabs.R.
This is a CORE interactive widget — mirror the accordion exemplar closely.
Static nav:
- bs_nav(..., type=NULL, fill=FALSE, justified=FALSE, vertical=FALSE, class=NULL): <ul class="nav
  nav-tabs|nav-pills? nav-fill? nav-justified? flex-column?">. type in c("tabs","pills"). attach_deps.
- bs_nav_item(..., class=NULL): <li class="nav-item">.
- bs_nav_link(..., href="#", active=FALSE, disabled=FALSE, id=NULL, class=NULL): <a class="nav-link active? disabled?"
  href {aria-current="page" if active}>. (Used also by navbar.)
Interactive tabset:
- bs_tabset(id, ..., type="tabs", selected=NULL, fill=FALSE, justified=FALSE, vertical=FALSE, class=NULL):
  panels are bs_tab_panel(). Build a <ul class="nav nav-{type}" role="tablist" id="{id}" data-bootstrict="tabset">
  with one <li class="nav-item" role="presentation"><button class="nav-link active?" id="{id}-tab-{i}"
  data-bs-toggle="tab" data-bs-target="#{id}-pane-{i}" type="button" role="tab" aria-controls="{id}-pane-{i}"
  aria-selected="true|false" data-value="{value}">{title}</button></li> per panel, and a
  <div class="tab-content"> with <div class="tab-pane fade show? active?" id="{id}-pane-{i}" role="tabpanel"
  aria-labelledby="{id}-tab-{i}" data-value="{value}">{body}</div> per panel. The selected panel (selected= matches
  value, default first) gets active/show. For vertical=TRUE wrap nav + content in a flex row (e.g.
  <div class="d-flex align-items-start"> nav with flex-column + content). Wrap everything (nav+content) in a parent
  <div> and attach_deps.
- bs_tab_panel(title, ..., value=NULL, icon=NULL, class=NULL): return structure(list(title,value=value%||%title,icon,
  body=list(...),class), class="bs_tab_panel"); bs_tabset validates inherits "bs_tab_panel" and requires unique values.
- update_bs_tabset(id, selected, session=...): bs_send("tabset.update", id=bs_ns(id,session), selected).
binding-tabset.js: eventBinding name "bootstrict.tabset", selector ".nav[data-bootstrict='tabset']",
events ["shown.bs.tab"], getValue = data-value of the active ".nav-link.active" button.
bootstrict.addHandler("tabset.update", msg => find the nav #id, find button with data-value===selected, call
bootstrict.bs("Tab", button).show()).`
  },
  {
    key: 'navbar',
    label: 'navbar',
    spec: `Group "navbar" -> files: R/navbar.R, tests/testthat/test-navbar.R. (No JS — pure Bootstrap behaviour.)
- bs_navbar(..., brand=NULL, id="navbar", expand="lg", bg=NULL, theme=NULL, placement=NULL, fluid=TRUE, class=NULL):
  <nav class="navbar navbar-expand-{expand} bg-{bg}? {placement}?" {data-bs-theme=theme}> <div class="container{-fluid}">
  {brand} <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#{id}-collapse"
  aria-controls="{id}-collapse" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
  <div class="collapse navbar-collapse" id="{id}-collapse">{...}</div> </div></nav>. theme in c("light","dark") ->
  data-bs-theme. bg uses check_color() (background). placement in c("fixed-top","fixed-bottom","sticky-top","sticky-bottom").
  expand may be a breakpoint or TRUE ("navbar-expand"). attach_deps on <nav>.
- bs_navbar_brand(..., href="#", class=NULL): <a class="navbar-brand" href>.
- bs_navbar_nav(..., class=NULL): <ul class="navbar-nav">; build items with <li class="nav-item"> wrapping
  bs_nav_link()-style <a class="nav-link">. You MAY call bs_nav_link()/bs_nav_item() (defined in R/nav-tabs.R) — do not redefine them.
- bs_navbar_text(..., class=NULL): <span class="navbar-text">.
You MAY also use bs_dropdown() (R/dropdown.R) inside navbars; do not redefine it.`
  },
  {
    key: 'dropdown',
    label: 'dropdown',
    spec: `Group "dropdown" -> files: R/dropdown.R, tests/testthat/test-dropdown.R. (Bootstrap handles toggle; items with
id reuse shiny's action-button binding so no custom JS is required.)
- bs_dropdown(label, ..., color="secondary", outline=FALSE, size=NULL, split=FALSE, direction="down", dark=FALSE,
  align=NULL, class=NULL): wrapper <div class="dropdown dropup|dropend|dropstart? btn-group?(if split)">.
  Toggle button: <button type="button" class="btn btn-{color}|btn-outline-{color} btn-{size}? dropdown-toggle"
  data-bs-toggle="dropdown" aria-expanded="false">{label}</button>. If split=TRUE render a normal button with {label}
  plus a second <button class="btn ... dropdown-toggle dropdown-toggle-split" data-bs-toggle="dropdown"><span class="visually-hidden">Toggle Dropdown</span></button>.
  Menu: <ul class="dropdown-menu dropdown-menu-dark? dropdown-menu-end?">{...items}</ul> where align="end" -> dropdown-menu-end
  (a named list -> responsive dropdown-menu-{bp}-end). color via c(bs_theme_colors,"link"). attach_deps.
- bs_dropdown_item(..., id=NULL, href="#", active=FALSE, disabled=FALSE, class=NULL): <li><a class="dropdown-item active? disabled?"
  href {class action-button if id} id?>children</a></li>. (id makes it a server action button via shiny's binding -> input$id click count.)
- bs_dropdown_divider(class=NULL): <li><hr class="dropdown-divider"></li>.
- bs_dropdown_header(..., level=6, class=NULL): <li><h{level} class="dropdown-header">.
- bs_dropdown_text(..., class=NULL): <li><span class="dropdown-item-text">.`
  },
  {
    key: 'modal',
    label: 'modal',
    spec: `Group "modal" -> files: R/modal.R, inst/assets/js/binding-modal.js, tests/testthat/test-modal.R.
- bs_modal(id, ..., title=NULL, footer=NULL, size=NULL, centered=FALSE, scrollable=FALSE, fullscreen=FALSE,
  backdrop=TRUE, keyboard=TRUE, class=NULL): <div class="modal fade" id tabindex="-1" aria-hidden="true"
  data-bootstrict="modal" {data-bs-backdrop="static" if backdrop=="static"|FALSE} {data-bs-keyboard="false" if !keyboard}>
  <div class="modal-dialog modal-{size}? modal-dialog-centered? modal-dialog-scrollable? modal-fullscreen?(TRUE or modal-fullscreen-{bp}-down)">
  <div class="modal-content"> <div class="modal-header"><h1 class="modal-title fs-5">{title}</h1>{bs_close_button(data-bs-dismiss="modal")}</div>
  <div class="modal-body">{...}</div> {if footer: <div class="modal-footer">{footer}</div>} </div></div></div>.
  size in sm/lg/xl. Use bs_close_button() from R/alert.R. attach_deps.
- bs_modal_header/bs_modal_body/bs_modal_footer/bs_modal_title helper constructors (for users who want full control
  instead of title/footer args).
- bs_modal_trigger(target, ..., class=NULL): a <button class="btn"> (or use bs_button) with
  data-bs-toggle="modal" data-bs-target="#{target}".
- show_bs_modal(id, session=...) -> bs_send("modal.show", id=bs_ns(id,session)); hide_bs_modal(id, session=...) -> "modal.hide";
  toggle_bs_modal -> "modal.toggle".
binding-modal.js: eventBinding name "bootstrict.modal", selector ".modal[data-bootstrict='modal']",
events ["shown.bs.modal","hidden.bs.modal"], getValue = el.classList.contains("show").
Handlers modal.show/modal.hide/modal.toggle -> bootstrict.bs("Modal", el).show()/hide()/toggle().`
  },
  {
    key: 'offcanvas',
    label: 'offcanvas',
    spec: `Group "offcanvas" -> files: R/offcanvas.R, inst/assets/js/binding-offcanvas.js, tests/testthat/test-offcanvas.R.
- bs_offcanvas(id, ..., title=NULL, placement="start", backdrop=TRUE, scroll=FALSE, class=NULL):
  <div class="offcanvas offcanvas-{placement}" tabindex="-1" id data-bootstrict="offcanvas"
  {data-bs-backdrop="false" if !backdrop, "static" if backdrop=="static"} {data-bs-scroll="true" if scroll}>
  <div class="offcanvas-header"><h5 class="offcanvas-title">{title}</h5>{bs_close_button(data-bs-dismiss="offcanvas")}</div>
  <div class="offcanvas-body">{...}</div></div>. placement in start/end/top/bottom. attach_deps.
- bs_offcanvas_trigger(target, ..., class=NULL): <button class="btn" data-bs-toggle="offcanvas" data-bs-target="#{target}"
  aria-controls="{target}">.
- show_bs_offcanvas(id)/hide_bs_offcanvas(id)/toggle_bs_offcanvas(id) (session=...) -> bs_send("offcanvas.show|hide|toggle", id=bs_ns(id)).
binding-offcanvas.js: eventBinding name "bootstrict.offcanvas", selector ".offcanvas[data-bootstrict='offcanvas']",
events ["shown.bs.offcanvas","hidden.bs.offcanvas"], getValue = el.classList.contains("show");
handlers offcanvas.show/hide/toggle -> bootstrict.bs("Offcanvas", el).show()/hide()/toggle().`
  },
  {
    key: 'carousel',
    label: 'carousel',
    spec: `Group "carousel" -> files: R/carousel.R, inst/assets/js/binding-carousel.js, tests/testthat/test-carousel.R.
- bs_carousel(id, ..., indicators=TRUE, controls=TRUE, fade=FALSE, autoplay=TRUE, interval=NULL, dark=FALSE, class=NULL):
  items are bs_carousel_item(). <div id class="carousel slide carousel-fade? carousel-dark?" data-bootstrict="carousel"
  {data-bs-ride="carousel" if autoplay==TRUE else "true"? } {data-bs-interval=interval}>. If indicators: a
  <div class="carousel-indicators"> with one <button type="button" data-bs-target="#{id}" data-bs-slide-to="{i-1}"
  class="active?" aria-current="true?" aria-label="Slide {i}"> per item. Then <div class="carousel-inner">{items}</div>.
  If controls: <button class="carousel-control-prev" type="button" data-bs-target="#{id}" data-bs-slide="prev">
  <span class="carousel-control-prev-icon" aria-hidden="true"></span><span class="visually-hidden">Previous</span></button>
  and the matching ...-next. Ensure exactly one item is active (default first). attach_deps.
- bs_carousel_item(..., active=FALSE, interval=NULL, caption=NULL, class=NULL): <div class="carousel-item active?"
  {data-bs-interval=interval}>{...}{if caption: <div class="carousel-caption d-none d-md-block">{caption}</div>}</div>.
- update_bs_carousel(id, to=NULL, slide=NULL, session=...): bs_send("carousel.update", id=bs_ns(id), to, slide)
  where slide in "next"/"prev".
binding-carousel.js: eventBinding name "bootstrict.carousel", selector ".carousel[data-bootstrict='carousel']",
events ["slid.bs.carousel"], getValue: index of the active .carousel-item among .carousel-item siblings (0-based).
Handler carousel.update: if msg.to!=null bootstrict.bs("Carousel", el).to(msg.to); else if msg.slide==="next" .next();
else if "prev" .prev().`
  },
  {
    key: 'collapse',
    label: 'collapse',
    spec: `Group "collapse" -> files: R/collapse.R, inst/assets/js/binding-collapse.js, tests/testthat/test-collapse.R.
- bs_collapse(id, ..., open=FALSE, horizontal=FALSE, class=NULL): <div class="collapse show? collapse-horizontal?"
  id data-bootstrict="collapse">{...}</div>. attach_deps.
- bs_collapse_trigger(target, ..., button=TRUE, class=NULL): if button -> <button class="btn" type="button"
  data-bs-toggle="collapse" data-bs-target="#{target}" aria-expanded="false" aria-controls="{target}">{...}</button>;
  else <a class="..." data-bs-toggle="collapse" href="#{target}" role="button" aria-expanded="false" aria-controls="{target}">.
- update_bs_collapse(id, action=c("toggle","show","hide"), session=...): bs_send("collapse.update", id=bs_ns(id), action).
binding-collapse.js: eventBinding name "bootstrict.collapse", selector ".collapse[data-bootstrict='collapse']",
events ["shown.bs.collapse","hidden.bs.collapse"], getValue = el.classList.contains("show").
Handler collapse.update -> bootstrict.bs("Collapse", el)[action]() where action in show/hide/toggle.`
  },
  {
    key: 'toast',
    label: 'toast',
    spec: `Group "toast" -> files: R/toast.R, inst/assets/js/binding-toast.js, tests/testthat/test-toast.R.
- bs_toast(id, ..., title=NULL, icon=NULL, autohide=TRUE, delay=5000, animation=TRUE, class=NULL):
  <div id class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-bootstrict="toast"
  {data-bs-autohide="false" if !autohide} {data-bs-delay=delay} {data-bs-animation="false" if !animation}>
  {if title: <div class="toast-header">{icon}<strong class="me-auto">{title}</strong>{bs_close_button(data-bs-dismiss="toast")}</div>}
  <div class="toast-body">{...}</div></div>. Use bs_close_button() from R/alert.R. attach_deps.
- bs_toast_container(..., placement="top-end", class=NULL): <div class="toast-container position-fixed p-3 {pos}">
  where placement maps: top-start->"top-0 start-0", top-center->"top-0 start-50 translate-middle-x",
  top-end->"top-0 end-0", middle-center->"top-50 start-50 translate-middle", bottom-start->"bottom-0 start-0",
  bottom-end->"bottom-0 end-0", etc. attach_deps.
- show_bs_toast(id)/hide_bs_toast(id) (session=...) -> bs_send("toast.show|hide", id=bs_ns(id)).
- bs_notify_toast(body, ..., title=NULL, color=NULL, delay=5000, placement="top-end", session=...): server-side helper
  that builds a toast on the client and shows it (like shiny::showNotification). bs_send("toast.notify",
  body, title, color, delay, placement). check_color(color).
binding-toast.js: eventBinding name "bootstrict.toast", selector ".toast[data-bootstrict='toast']",
events ["shown.bs.toast","hidden.bs.toast"], getValue = el.classList.contains("show").
Handlers: toast.show/hide -> bootstrict.bs("Toast", el).show()/hide(). toast.notify -> find or create a
.toast-container (use placement classes), create a .toast element (with optional .toast-header strong title +
btn-close, .toast-body with body, text-bg-{color} class if color), append it, new bootstrap.Toast(node,{delay}).show(),
and remove the node on "hidden.bs.toast".`
  },
  {
    key: 'behaviors',
    label: 'tooltip+popover+scrollspy',
    spec: `Group "behaviors" -> files: R/behaviors.R, inst/assets/js/binding-behaviors.js, tests/testthat/test-behaviors.R.
Tooltips and popovers must be initialised in JS (Bootstrap does not auto-init them).
- bs_tooltip(tag, title, ..., placement="top", html=FALSE, trigger=NULL): take a UI element (a shiny.tag) and add
  attributes data-bs-toggle="tooltip", title={title}, data-bs-placement={placement}, {data-bs-html="true" if html},
  {data-bs-trigger=trigger}, and data-bootstrict-tip="tooltip"; return the tag via attach_deps. Use htmltools::tagAppendAttributes.
- bs_popover(tag, content, ..., title=NULL, placement="right", trigger="click", html=FALSE):
  add data-bs-toggle="popover", data-bs-content={content}, {title=title}, data-bs-placement, data-bs-trigger,
  {data-bs-html} and data-bootstrict-tip="popover"; attach_deps.
- bs_scrollspy(target, ..., offset=NULL, smooth=TRUE, class=NULL): <div data-bs-spy="scroll"
  data-bs-target="#{target}" {data-bs-offset=offset} {data-bs-smooth-scroll="true" if smooth} tabindex="0"
  class={class}>{...}</div>. attach_deps.
- bs_visually_hidden(..., class=NULL): <span class="visually-hidden">.
- bs_ratio(..., ratio="16x9", class=NULL): <div class="ratio ratio-{ratio}"> (ratio in 1x1/4x3/16x9/21x9).
- bs_vr(class=NULL): <div class="vr">.
binding-behaviors.js: register TWO bindings via bootstrict.eventBinding with no events and a getValue returning null,
that initialise on bind:
  - name "bootstrict.tooltip", selector "[data-bootstrict-tip='tooltip']", initialize: el => bootstrict.bs("Tooltip", el).
  - name "bootstrict.popover",  selector "[data-bootstrict-tip='popover']",  initialize: el => bootstrict.bs("Popover", el).
  getId should fall back to a generated value if el has no id (e.g. return el.id || ("bstip-"+Math.round performance.now())).
  Since these aren't real inputs, getValue: function(){ return null; } is fine.`
  }
]

phase('Generate')

const FILE_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['group', 'files_written', 'exports', 'parse_ok'],
  properties: {
    group: { type: 'string' },
    files_written: { type: 'array', items: { type: 'string' } },
    exports: { type: 'array', items: { type: 'string' } },
    interactive: { type: 'boolean' },
    parse_ok: { type: 'boolean', description: 'true if Rscript parse() of the R file exited cleanly' },
    notes: { type: 'string' }
  }
}

const results = await parallel(TASKS.map(function (t) {
  return function () {
    return agent(PREAMBLE + t.spec, {
      label: t.label,
      phase: 'Generate',
      agentType: 'general-purpose',
      schema: FILE_SCHEMA
    })
  }
}))

const ok = results.filter(Boolean)
log('Generated ' + ok.length + '/' + TASKS.length + ' groups')
return {
  groups: ok,
  failed: TASKS.filter(function (t, i) { return !results[i] }).map(function (t) { return t.key })
}
