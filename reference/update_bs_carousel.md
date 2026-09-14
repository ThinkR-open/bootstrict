# Control a carousel from the server

Control a carousel from the server

## Usage

``` r
update_bs_carousel(
  id,
  to = NULL,
  slide = NULL,
  action = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Carousel id (namespaced automatically inside modules).

- to:

  0-based index of the slide to cycle to. Takes precedence over `slide`
  when both are supplied.

- slide:

  Direction to advance: `"next"` or `"prev"`.

- action:

  `"pause"` stops cycling, `"cycle"` resumes it.

- session:

  The Shiny session.

## Value

Invisibly `NULL`, called for its side effect.

## Examples

``` r
if (FALSE) { # \dontrun{
update_bs_carousel("demo", to = 2)
update_bs_carousel("demo", slide = "next")
} # }
```
