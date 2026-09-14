# Bootstrap accordion

A vertically collapsing set of panels. The value(s) of the currently
open panel(s) are reported to the server as `input$id`, and can be
driven server-side with
[`update_bs_accordion()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_accordion.md).

## Usage

``` r
bs_accordion(
  id,
  ...,
  open = NULL,
  multiple = FALSE,
  flush = FALSE,
  class = NULL
)

bs_accordion_panel(
  title,
  ...,
  value = NULL,
  icon = NULL,
  class = NULL,
  body_class = NULL
)
```

## Arguments

- id:

  Accordion id; open panel value(s) available as `input$id`.

- ...:

  Panels built with `bs_accordion_panel()`.

- open:

  Panel value(s) open initially. Use `TRUE` to open all (only sensible
  with `multiple = TRUE`), `FALSE`/`NULL` for none.

- multiple:

  If `TRUE`, panels stay open independently (Bootstrap "always open").
  Otherwise opening one closes the others.

- flush:

  If `TRUE`, render edge-to-edge without borders (`.accordion-flush`).

- class:

  Extra classes.

- title:

  Panel header content.

- value:

  Panel identifier reported to the server (defaults to `title`).

- icon:

  Optional icon placed before the title.

- body_class:

  Extra classes for the panel body.

## Value

An accordion tag.

## Examples

``` r
bs_accordion(
  "acc",
  bs_accordion_panel("First", "Panel one body", value = "one"),
  bs_accordion_panel("Second", "Panel two body", value = "two"),
  open = "one"
)
#> <div id="acc" class="accordion" data-bootstrict="accordion">
#>   <div class="accordion-item">
#>     <h2 class="accordion-header">
#>       <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#acc-panel-1" aria-expanded="true" aria-controls="acc-panel-1">First</button>
#>     </h2>
#>     <div id="acc-panel-1" class="accordion-collapse collapse show" data-value="one" data-bs-parent="#acc">
#>       <div class="accordion-body">Panel one body</div>
#>     </div>
#>   </div>
#>   <div class="accordion-item">
#>     <h2 class="accordion-header">
#>       <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#acc-panel-2" aria-expanded="false" aria-controls="acc-panel-2">Second</button>
#>     </h2>
#>     <div id="acc-panel-2" class="accordion-collapse collapse" data-value="two" data-bs-parent="#acc">
#>       <div class="accordion-body">Panel two body</div>
#>     </div>
#>   </div>
#> </div>
```
