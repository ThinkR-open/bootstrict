# Bootstrap toast

A lightweight, dismissible notification. The toast's visibility is
reported to the server as `input$id` (`TRUE` when shown), and can be
driven server-side with
[`show_bs_toast()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_toast.md)
/
[`hide_bs_toast()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_toast.md).
Place one or more toasts inside a
[`bs_toast_container()`](https://thinkr-open.github.io/bootstrict/reference/bs_toast_container.md)
to position them on screen, or push transient notifications entirely
from the server with
[`bs_notify_toast()`](https://thinkr-open.github.io/bootstrict/reference/bs_notify_toast.md).

## Usage

``` r
bs_toast(
  id,
  ...,
  title = NULL,
  icon = NULL,
  autohide = TRUE,
  delay = 5000,
  animation = TRUE,
  class = NULL
)
```

## Arguments

- id:

  Toast id; shown state available as `input$id`.

- ...:

  Toast body content and named HTML attributes applied to the root.

- title:

  Optional header title. When supplied, a `.toast-header` with the title
  and a close button is rendered.

- icon:

  Optional icon placed before the title in the header.

- autohide:

  If `TRUE` (default), hide the toast automatically after `delay`
  milliseconds.

- delay:

  Delay in milliseconds before auto-hiding (when `autohide`).

- animation:

  If `FALSE`, disable the fade animation.

- class:

  Extra classes.

## Value

A toast tag.

## Examples

``` r
bs_toast("hello", "Hello, world!", title = "Bootstrict")
#> <div id="hello" class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-bootstrict="toast" data-bs-delay="5000">
#>   <div class="toast-header">
#>     <strong class="me-auto">Bootstrict</strong>
#>     <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="toast"></button>
#>   </div>
#>   <div class="toast-body">Hello, world!</div>
#> </div>
```
