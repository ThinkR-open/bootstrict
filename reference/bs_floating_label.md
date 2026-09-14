# Bootstrap floating label

Reshape a control built by one of the `bs_*_input()` constructors (e.g.
[`bs_text_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_text_input.md),
[`bs_select_input()`](https://thinkr-open.github.io/bootstrict/reference/bs_select_input.md))
into a Bootstrap 5 floating-label group, where the label animates into
the control's border. The existing control and its Shiny input wiring
are preserved (the element is moved, not rebuilt), so the value still
reports as `input$id`.

## Usage

``` r
bs_floating_label(input, label = NULL, class = NULL)
```

## Arguments

- input:

  A control tag tree produced by a `bs_*_input()` constructor.

- label:

  Floating label text. If `NULL`, the control's existing label text is
  reused.

- class:

  Extra classes.

## Value

A `.form-floating` wrapper tag.

## Examples

``` r
bs_floating_label(bs_text_input("email", "Email address"))
#> <div class="form-floating">
#>   <input id="email" type="text" class="shiny-input-text form-control" value="" data-update-on="change" placeholder=" "/>
#>   <label for="email">Email address</label>
#> </div>
```
