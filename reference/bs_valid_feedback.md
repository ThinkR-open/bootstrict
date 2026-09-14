# Bootstrap validation feedback

Inline messages shown next to a control to convey its validation state.
`bs_valid_feedback()` renders `.valid-feedback`; `bs_invalid_feedback()`
renders `.invalid-feedback`.

## Usage

``` r
bs_valid_feedback(..., class = NULL)

bs_invalid_feedback(..., class = NULL)
```

## Arguments

- ...:

  Feedback content and named HTML attributes.

- class:

  Extra classes.

## Value

A div tag.

## Examples

``` r
bs_valid_feedback("Looks good!")
#> <div class="valid-feedback">Looks good!</div>
bs_invalid_feedback("Please choose a username.")
#> <div class="invalid-feedback">Please choose a username.</div>
```
