# Bootstrap button group / toolbar

Bootstrap button group / toolbar

## Usage

``` r
bs_button_group(..., size = NULL, vertical = FALSE, label = NULL, class = NULL)

bs_button_toolbar(..., label = NULL, class = NULL)
```

## Arguments

- ...:

  Buttons
  ([`bs_button()`](https://thinkr-open.github.io/bootstrict/reference/bs_button.md))
  and named HTML attributes.

- size:

  `"sm"` or `"lg"`.

- vertical:

  If `TRUE`, stack vertically (`.btn-group-vertical`).

- label:

  Accessible label (`aria-label`).

- class:

  Extra classes.

## Value

A button group / toolbar tag.

## Examples

``` r
bs_button_group(bs_button(label = "Left"), bs_button(label = "Right"))
#> <div class="btn-group" role="group">
#>   <button class="btn btn-primary" type="button">Left</button>
#>   <button class="btn btn-primary" type="button">Right</button>
#> </div>
bs_button_toolbar(
  bs_button_group(bs_button(label = "Cut")),
  bs_button_group(bs_button(label = "Copy"))
)
#> <div class="btn-toolbar" role="toolbar">
#>   <div class="btn-group" role="group">
#>     <button class="btn btn-primary" type="button">Cut</button>
#>   </div>
#>   <div class="btn-group" role="group">
#>     <button class="btn btn-primary" type="button">Copy</button>
#>   </div>
#> </div>
```
