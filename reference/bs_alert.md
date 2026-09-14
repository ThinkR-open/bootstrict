# Bootstrap alert

Given an `id`, a dismissible alert reports whether it is still on the
page as `input$id` (`TRUE` until it is dismissed, `FALSE` once it is)
and can be closed from the server with
[`close_bs_alert()`](https://thinkr-open.github.io/bootstrict/reference/close_bs_alert.md).

## Usage

``` r
bs_alert(..., id = NULL, color = "primary", dismissible = FALSE, class = NULL)

bs_alert_heading(..., level = 4, class = NULL)

bs_alert_link(..., href = "#", class = NULL)
```

## Arguments

- ...:

  Alert content and named HTML attributes.

- id:

  Optional alert id. Its visibility is reported as `input$id`.

- color:

  Theme colour (`.alert-*`). Defaults to `"primary"`.

- dismissible:

  If `TRUE`, add a close button and fade-out behaviour.

- class:

  Extra classes.

- level:

  Heading level (1-6).

- href:

  Link target.

## Value

An alert tag.

## See also

[`close_bs_alert()`](https://thinkr-open.github.io/bootstrict/reference/close_bs_alert.md)

## Examples

``` r
bs_alert("Well done!", color = "success")
#> <div class="alert alert-success" role="alert">Well done!</div>
bs_alert("Heads up.", color = "warning", dismissible = TRUE)
#> <div class="alert alert-warning alert-dismissible fade show" role="alert">
#>   Heads up.
#>   <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="alert"></button>
#> </div>
bs_alert(
  bs_alert_heading("Well done"),
  "You read ", bs_alert_link("the docs", href = "#"), ".",
  color = "success"
)
#> <div class="alert alert-success" role="alert">
#>   <h4 class="alert-heading">Well done</h4>
#>   You read 
#>   <a href="#" class="alert-link">the docs</a>
#>   .
#> </div>
```
