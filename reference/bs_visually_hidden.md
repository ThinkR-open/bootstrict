# Visually hidden text

Renders content available to assistive technologies but hidden from
sighted users (`.visually-hidden`).

## Usage

``` r
bs_visually_hidden(..., class = NULL)
```

## Arguments

- ...:

  Content and named HTML attributes.

- class:

  Extra classes.

## Value

A `<span>` tag.

## Examples

``` r
bs_visually_hidden("Loading, please wait")
#> <span class="visually-hidden">Loading, please wait</span>
```
