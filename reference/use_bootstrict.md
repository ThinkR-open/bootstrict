# Activate bootstrict inside a UI

Returns the bootstrict HTML dependency (Shiny input bindings +
supporting CSS) so it can be dropped anywhere in a UI. Page constructors
such as
[`bs_page()`](https://thinkr-open.github.io/bootstrict/reference/bs_page.md)
call this for you; use it directly when embedding bootstrict widgets
into a UI you build by hand.

## Usage

``` r
use_bootstrict()
```

## Value

An
[htmltools::htmlDependency](https://rstudio.github.io/htmltools/reference/htmlDependency.html).

## Examples

``` r
shiny::fluidPage(use_bootstrict(), bs_card(bs_card_body("Hello")))
#> <div class="container-fluid">
#>   <div class="card">
#>     <div class="card-body">Hello</div>
#>   </div>
#> </div>
```
