# Bootstrap stacks (horizontal / vertical flex layouts)

Shorthand flex helpers added in Bootstrap 5.1. `bs_hstack()` lays
children out in a row, `bs_vstack()` in a column.

## Usage

``` r
bs_hstack(..., gap = NULL, class = NULL)

bs_vstack(..., gap = NULL, class = NULL)
```

## Arguments

- ...:

  Content, and named HTML attributes.

- gap:

  Spacing between items (`gap-*`), an integer `0`-`5`.

- class:

  Extra classes.

## Value

A stack tag.

## Examples

``` r
bs_hstack(bs_button(label = "A"), bs_button(label = "B"), gap = 2)
#> <div class="hstack gap-2">
#>   <button class="btn btn-primary" type="button">A</button>
#>   <button class="btn btn-primary" type="button">B</button>
#> </div>
bs_vstack(bs_alert("one"), bs_alert("two"), gap = 3)
#> <div class="vstack gap-3">
#>   <div class="alert alert-primary" role="alert">one</div>
#>   <div class="alert alert-primary" role="alert">two</div>
#> </div>
```
