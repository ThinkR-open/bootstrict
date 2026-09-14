# Bootstrap blockquote

Bootstrap blockquote

## Usage

``` r
bs_blockquote(..., footer = NULL, class = NULL)
```

## Arguments

- ...:

  Quote content and named HTML attributes applied to the `<blockquote>`.

- footer:

  Optional source/attribution rendered in a `.blockquote-footer`.

- class:

  Extra classes applied to the `<blockquote>`.

## Value

A figure tag wrapping the blockquote.

## Examples

``` r
bs_blockquote("A well-known quote.", footer = "Someone famous")
#> <figure>
#>   <blockquote class="blockquote">A well-known quote.</blockquote>
#>   <figcaption class="blockquote-footer">Someone famous</figcaption>
#> </figure>
```
