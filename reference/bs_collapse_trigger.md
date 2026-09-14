# Trigger a collapse from the UI

Renders a control that toggles the
[`bs_collapse()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse.md)
whose id matches `target`, using Bootstrap's declarative
`data-bs-toggle="collapse"` attributes (no server round trip required).

## Usage

``` r
bs_collapse_trigger(target, ..., button = TRUE, expanded = FALSE, class = NULL)
```

## Arguments

- target:

  Id of the
  [`bs_collapse()`](https://thinkr-open.github.io/bootstrict/reference/bs_collapse.md)
  to toggle.

- ...:

  Content (label) and named HTML attributes.

- button:

  If `TRUE` (default), render a `<button class="btn">`; otherwise render
  an `<a role="button">`.

- expanded:

  Initial expanded state of the trigger. Set to `TRUE` when the target
  is a `bs_collapse(open = TRUE)` so the initial `aria-expanded` /
  `.collapsed` state is correct.

- class:

  Extra classes.

## Value

A button (or anchor) tag.

## Examples

``` r
bs_collapse_trigger("more", "Toggle")
#> <button class="btn collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#more" aria-expanded="false" aria-controls="more">Toggle</button>
```
