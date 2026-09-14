# Set a control's validation state from the server

Toggles `.is-valid` / `.is-invalid` on the control registered under `id`
and, when `message` is supplied, replaces the text of the matching
feedback message declared with
[`bs_feedback()`](https://thinkr-open.github.io/bootstrict/reference/bs_feedback.md).

## Usage

``` r
set_bs_validation(
  id,
  state = c("valid", "invalid", "none"),
  message = NULL,
  session = shiny::getDefaultReactiveDomain()
)
```

## Arguments

- id:

  Input id, as passed to the `bs_*_input()` constructor.

- state:

  `"valid"`, `"invalid"`, or `"none"` to clear the state.

- message:

  Optional replacement text for the feedback message. Plain text: it is
  set with `textContent`.

- session:

  The Shiny session.

## Value

Nothing, called for its side effect.

## See also

[`bs_feedback()`](https://thinkr-open.github.io/bootstrict/reference/bs_feedback.md)

## Examples

``` r
if (interactive()) {
  set_bs_validation("user", "invalid", "That name is taken.")
}
```
