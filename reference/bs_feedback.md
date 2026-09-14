# Attach validation feedback to a form control

Bootstrap only shows a `.valid-feedback` / `.invalid-feedback` message
when it is a *following sibling* of the control carrying `.is-valid` /
`.is-invalid`. A feedback div placed after a `bs_*_input()` is a sibling
of shiny's input container, not of the control inside it, so it would
never display. `bs_feedback()` inserts the messages in the right place,
whatever the control's internal structure, and is the supported way to
validate a bootstrict input.

## Usage

``` r
bs_feedback(input, valid = NULL, invalid = NULL, state = NULL)
```

## Arguments

- input:

  A control tag tree produced by a `bs_*_input()` constructor.

- valid:

  Message shown when the control is valid, or `NULL` for none.

- invalid:

  Message shown when the control is invalid, or `NULL`.

- state:

  Initial state: `"valid"`, `"invalid"` or `NULL` (neutral).

## Value

The input, with the feedback messages attached.

## Details

Declare the messages in the UI and switch the state from the server with
[`set_bs_validation()`](https://thinkr-open.github.io/bootstrict/reference/set_bs_validation.md).

## See also

[`set_bs_validation()`](https://thinkr-open.github.io/bootstrict/reference/set_bs_validation.md),
[`bs_valid_feedback()`](https://thinkr-open.github.io/bootstrict/reference/bs_valid_feedback.md)

## Examples

``` r
bs_feedback(
  bs_text_input("user", "Username"),
  invalid = "Please choose a username."
)
#> <div class="form-group shiny-input-container">
#>   <label class="control-label form-label" for="user" id="user-label">Username</label>
#>   <input id="user" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>   <div class="invalid-feedback">Please choose a username.</div>
#> </div>
```
