# Bootstrap form help text

Muted helper text rendered below a control (`.form-text`).

## Usage

``` r
bs_form_text(..., class = NULL)
```

## Arguments

- ...:

  Help content and named HTML attributes.

- class:

  Extra classes.

## Value

A div tag.

## Examples

``` r
bs_form_text("Must be 8-20 characters long.")
#> <div class="form-text">Must be 8-20 characters long.</div>
```
