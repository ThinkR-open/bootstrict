# Bootstrap password input

Bootstrap password input

## Usage

``` r
bs_password_input(
  id,
  label = NULL,
  value = "",
  ...,
  size = NULL,
  help = NULL,
  width = NULL
)
```

## Arguments

- id:

  Input id; value available as `input$id`.

- label:

  Input label.

- value:

  Initial value.

- ...:

  Extra attributes applied to the `<input>` element.

- size:

  Control size: `"sm"` or `"lg"`.

- help:

  Help text rendered below the control (`.form-text`).

- width:

  CSS width (e.g. `"100%"`, `"200px"`).

## Value

A form control tag.

## See also

[`shiny::passwordInput()`](https://rdrr.io/pkg/shiny/man/passwordInput.html)

## Examples

``` r
bs_password_input("pw", "Password", help = "At least 8 characters.")
#> <div class="form-group shiny-input-container">
#>   <label class="control-label form-label" for="pw" id="pw-label">Password</label>
#>   <input id="pw" type="password" class="shiny-input-password form-control" value="" data-update-on="change" aria-describedby="pw-help"/>
#>   <div id="pw-help" class="form-text">At least 8 characters.</div>
#> </div>
```
