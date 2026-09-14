# Bootstrap input group

Groups one or more form controls together with add-ons (text, buttons,
dropdowns) on a single line.

## Usage

``` r
bs_input_group(..., size = NULL, class = NULL)

bs_input_group_text(..., class = NULL)
```

## Arguments

- ...:

  Controls and add-ons (e.g. `bs_input_group_text()`,
  [`bs_text_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_text_input.md),
  [`bs_button()`](https://thinkr-open.github.io/bootstrict/reference/bs_button.md))
  and named HTML attributes.

- size:

  Control size: `"sm"` or `"lg"`.

- class:

  Extra classes.

## Value

An input-group tag.

## Details

When a full `bs_*_input()` is passed, only its bare control is kept so
it sits flush with the add-ons: the input's label and `help` text are
dropped (compose them outside the group). Inputs whose Shiny binding
lives on their container —
[`bs_date_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_input.md),
[`bs_date_range_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_date_range_input.md),
[`bs_file_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_file_input.md),
[`bs_radio_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_radio_input.md),
[`bs_checkbox_group_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_checkbox_group_input.md)
— cannot be unwrapped this way and raise an error.

## Examples

``` r
bs_input_group(
  bs_input_group_text("@"),
  bs_text_input("user", placeholder = "Username")
)
#> <div class="input-group">
#>   <span class="input-group-text">@</span>
#>   <input id="user" type="text" class="shiny-input-text form-control" value="" placeholder="Username" data-update-on="change"/>
#> </div>
```
