# Bootstrap form element

A plain `<form>` container for grouping form controls.

## Usage

``` r
bs_form(..., novalidate = FALSE, class = NULL)
```

## Arguments

- ...:

  Form content (controls, layout, buttons) and named HTML attributes.

- novalidate:

  If `TRUE`, add the `novalidate` attribute to disable the browser's
  native validation UI (useful with custom validation feedback).

- class:

  Extra classes.

## Value

A form tag.

## Examples

``` r
bs_form(
  bs_text_input("email", "Email"),
  bs_button("Submit", color = "primary")
)
#> <form>
#>   <div class="form-group shiny-input-container">
#>     <label class="control-label form-label" for="email" id="email-label">Email</label>
#>     <input id="email" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>   </div>
#>   <button id="Submit" class="btn btn-primary action-button" type="button"></button>
#> </form>
```
