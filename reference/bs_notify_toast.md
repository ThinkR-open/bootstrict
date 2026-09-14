# Pop a transient toast notification from the server

Builds a toast on the client and shows it, much like
[`shiny::showNotification()`](https://rdrr.io/pkg/shiny/man/showNotification.html).
A toast container is created on demand at `placement` if one is not
already present, and the toast removes itself from the DOM once hidden.

## Usage

``` r
bs_notify_toast(
  body,
  ...,
  title = NULL,
  color = NULL,
  autohide = TRUE,
  delay = 5000,
  placement = "top-end",
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- body:

  Notification body text. Plain text only (it is inserted with
  `textContent` client-side, so markup is not interpreted); tags raise
  an error.

- ...:

  Reserved for future extensions; must be empty.

- title:

  Optional header title. Plain text only, like `body`.

- color:

  Optional theme colour applied as a `.text-bg-*` background.

- autohide:

  If `TRUE` (default), hide the toast automatically after `delay`
  milliseconds. Use `FALSE` for a persistent notification the user must
  dismiss.

- delay:

  Delay in milliseconds before the toast auto-hides.

- placement:

  Container placement (see
  [`bs_toast_container()`](https://thinkr-open.github.io/bootstrict/reference/bs_toast_container.md)).

- session:

  The Shiny session.

## Value

Invisibly `NULL`, called for its side effect.

## Examples

``` r
if (interactive()) bs_notify_toast("Saved!", title = "Status", color = "success")
```
