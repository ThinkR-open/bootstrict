# Bootstrap badge

A small count / labelling component rendered as a
`<span class="badge">`.

## Usage

``` r
bs_badge(..., color = "primary", pill = FALSE, class = NULL)
```

## Arguments

- ...:

  Badge content and named HTML attributes.

- color:

  Theme colour (`.text-bg-*`). Defaults to `"primary"`.

- pill:

  If `TRUE`, render with fully rounded corners (`.rounded-pill`).

- class:

  Extra classes.

## Value

A badge tag.

## Examples

``` r
bs_badge("New", color = "success")
#> <span class="badge text-bg-success">New</span>
```
