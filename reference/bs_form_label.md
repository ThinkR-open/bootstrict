# Bootstrap form label

A `<label class="form-label">` tied to a control via its `for`
attribute.

## Usage

``` r
bs_form_label(for_id, ..., class = NULL)
```

## Arguments

- for_id:

  The id of the control this label describes (rendered as the `for`
  attribute).

- ...:

  Label content and named HTML attributes.

- class:

  Extra classes.

## Value

A label tag.

## Examples

``` r
bs_form_label("email", "Email address")
#> <label class="form-label" for="email">Email address</label>
```
