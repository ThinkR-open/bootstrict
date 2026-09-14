# Bootstrap close button

Bootstrap close button

## Usage

``` r
bs_close_button(..., label = "Close", white = FALSE, class = NULL)
```

## Arguments

- ...:

  Named HTML attributes (e.g. `data-bs-dismiss`).

- label:

  Accessible label.

- white:

  If `TRUE`, the variant for dark backgrounds (`data-bs-theme="dark"` on
  the button — the Bootstrap 5.3 idiom; `.btn-close-white` is
  deprecated).

- class:

  Extra classes.

## Value

A button tag.

## Examples

``` r
bs_close_button()
#> <button type="button" class="btn-close" aria-label="Close"></button>
bs_close_button(`data-bs-dismiss` = "alert", white = TRUE)
#> <button type="button" class="btn-close" data-bs-theme="dark" aria-label="Close" data-bs-dismiss="alert"></button>
```
