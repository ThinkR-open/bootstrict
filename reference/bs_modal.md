# Bootstrap modal

A faithful Bootstrap 5 modal dialog. The modal's open/closed state is
reported to the server as `input$id` (`TRUE` when shown), and can be
driven server-side with
[`show_bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_modal.md),
[`hide_bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_modal.md)
and
[`toggle_bs_modal()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_modal.md).

## Usage

``` r
bs_modal(
  id,
  ...,
  title = NULL,
  footer = NULL,
  size = NULL,
  centered = FALSE,
  scrollable = FALSE,
  fullscreen = FALSE,
  backdrop = TRUE,
  keyboard = TRUE,
  class = NULL
)

bs_modal_header(..., class = NULL)

bs_modal_title(..., level = 1, class = NULL)

bs_modal_body(..., class = NULL)

bs_modal_footer(..., class = NULL)
```

## Arguments

- id:

  Modal id; open state available as `input$id`.

- ...:

  Modal body content and named HTML attributes applied to the root.

- title:

  Optional header title. When supplied, a `.modal-header` with a title
  and a close button is rendered.

- footer:

  Optional footer content (e.g. buttons), placed in a `.modal-footer`.

- size:

  Dialog size: `"sm"`, `"lg"` or `"xl"`.

- centered:

  If `TRUE`, vertically centre the dialog (`.modal-dialog-centered`).

- scrollable:

  If `TRUE`, scroll long bodies inside the dialog
  (`.modal-dialog-scrollable`).

- fullscreen:

  `TRUE` for an always-fullscreen modal, or a breakpoint
  (`"sm"`/`"md"`/`"lg"`/`"xl"`/`"xxl"`) for fullscreen below that
  breakpoint (`.modal-fullscreen-{bp}-down`).

- backdrop:

  Backdrop behaviour: `TRUE` (backdrop shown, dismiss on outside click),
  `"static"` (backdrop shown, do not dismiss on outside click) or
  `FALSE` (no backdrop at all).

- keyboard:

  If `FALSE`, the modal cannot be closed with the Escape key.

- class:

  Extra classes.

- level:

  Heading level (1-6) for the modal title.

## Value

A modal tag.

## Details

For full control over the dialog structure (in place of the `title` and
`footer` shortcuts) compose the body yourself with `bs_modal_header()`,
`bs_modal_body()` and `bs_modal_footer()`.

## Examples

``` r
bs_modal("info", "Modal body text.", title = "Heads up")
#> <div id="info" class="modal fade" tabindex="-1" aria-hidden="true" aria-labelledby="info-title" data-bootstrict="modal">
#>   <div class="modal-dialog">
#>     <div class="modal-content">
#>       <div class="modal-header">
#>         <h1 class="modal-title fs-5" id="info-title">Heads up</h1>
#>         <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="modal"></button>
#>       </div>
#>       <div class="modal-body">Modal body text.</div>
#>     </div>
#>   </div>
#> </div>

# Or compose the dialog yourself.
bs_modal(
  "info",
  bs_modal_header(bs_modal_title("Heads up")),
  bs_modal_body("Modal body text."),
  bs_modal_footer(bs_button("ok", "OK", color = "primary"))
)
#> <div id="info" class="modal fade" tabindex="-1" aria-hidden="true" aria-labelledby="info-title" data-bootstrict="modal">
#>   <div class="modal-dialog">
#>     <div class="modal-content">
#>       <div class="modal-header">
#>         <h1 class="modal-title fs-5" id="info-title">Heads up</h1>
#>         <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="modal"></button>
#>       </div>
#>       <div class="modal-body">Modal body text.</div>
#>       <div class="modal-footer">
#>         <button id="ok" class="btn btn-primary action-button" type="button">OK</button>
#>       </div>
#>     </div>
#>   </div>
#> </div>
```
