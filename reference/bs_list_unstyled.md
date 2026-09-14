# Bootstrap unstyled / inline lists

Remove a list's default styling (`.list-unstyled`) or lay items out
inline (`.list-inline`). Each unnamed `...` argument becomes one `<li>`;
named arguments become attributes of the `<ul>`.

## Usage

``` r
bs_list_unstyled(..., class = NULL)

bs_list_inline(..., class = NULL)
```

## Arguments

- ...:

  List items (unnamed) and named HTML attributes for the `<ul>`.

- class:

  Extra classes.

## Value

An unordered list tag.

## Examples

``` r
bs_list_unstyled("First", "Second", "Third")
#> <ul class="list-unstyled">
#>   <li>First</li>
#>   <li>Second</li>
#>   <li>Third</li>
#> </ul>
bs_list_inline("One", "Two", "Three")
#> <ul class="list-inline">
#>   <li class="list-inline-item">One</li>
#>   <li class="list-inline-item">Two</li>
#>   <li class="list-inline-item">Three</li>
#> </ul>
```
