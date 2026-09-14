# Close an alert from the server

Dismisses the
[`bs_alert()`](https://thinkr-open.github.io/bootstrict/reference/bs_alert.md)
registered under `id`, exactly as its close button does. Bootstrap
removes the element, so the alert cannot be brought back: render it from
a [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) if it has
to come and go.

## Usage

``` r
close_bs_alert(id, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- id:

  Alert id, as passed to
  [`bs_alert()`](https://thinkr-open.github.io/bootstrict/reference/bs_alert.md).

- session:

  The Shiny session.

## Value

Nothing, called for its side effect.

## See also

[`bs_alert()`](https://thinkr-open.github.io/bootstrict/reference/bs_alert.md)

## Examples

``` r
if (interactive()) close_bs_alert("saved")
```
