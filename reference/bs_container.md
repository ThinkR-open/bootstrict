# Bootstrap container

Bootstrap container

## Usage

``` r
bs_container(..., fluid = FALSE, breakpoint = NULL, class = NULL)
```

## Arguments

- ...:

  Content, and named HTML attributes.

- fluid:

  If `TRUE`, a full-width `.container-fluid`. Ignored when `breakpoint`
  is set.

- breakpoint:

  One of `"sm"`, `"md"`, `"lg"`, `"xl"`, `"xxl"` for a responsive
  `.container-{breakpoint}`.

- class:

  Extra classes.

## Value

A container tag.

## See also

[`bs_row()`](https://thinkr-open.github.io/bootstrict/reference/bs_row.md),
[`bs_col()`](https://thinkr-open.github.io/bootstrict/reference/bs_col.md)

## Examples

``` r
bs_container(bs_row(bs_col("a"), bs_col("b")))
#> <div class="container">
#>   <div class="row">
#>     <div class="col">a</div>
#>     <div class="col">b</div>
#>   </div>
#> </div>
```
