# Bootstrap spinner

An animated loading indicator. Render either a spinning border
(`type = "border"`) or a pulsing dot (`type = "grow"`), optionally
tinted with a theme colour and shrunk to the small variant.

## Usage

``` r
bs_spinner(
  type = c("border", "grow"),
  color = NULL,
  size = NULL,
  label = "Loading...",
  ...,
  class = NULL
)
```

## Arguments

- type:

  Spinner style: `"border"` (default) or `"grow"`.

- color:

  Theme colour (`.text-*`), one of the Bootstrap theme colours.

- size:

  Spinner size; only `"sm"` (small) is accepted, `NULL` for the default
  size.

- label:

  Visually hidden text announced to assistive technology.

- ...:

  Additional named HTML attributes applied to the spinner element.

- class:

  Extra classes.

## Value

A spinner tag.

## Examples

``` r
bs_spinner(type = "border", color = "primary")
#> <div class="spinner-border text-primary" role="status">
#>   <span class="visually-hidden">Loading...</span>
#> </div>
```
