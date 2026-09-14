# Bootstrap breadcrumb

A navigation hierarchy. Compose with `bs_breadcrumb_item()`.

## Usage

``` r
bs_breadcrumb(..., divider = NULL, label = "breadcrumb", class = NULL)

bs_breadcrumb_item(..., active = FALSE, href = NULL, class = NULL)
```

## Arguments

- ...:

  Breadcrumb items built with `bs_breadcrumb_item()`, plus named HTML
  attributes applied to the `<nav>`.

- divider:

  Optional custom divider character (e.g. `">"`). When a string, it is
  set via the `--bs-breadcrumb-divider` CSS variable on the `<nav>`.

- label:

  Accessible label for the `<nav>` (`aria-label`).

- class:

  Extra classes applied to the `<nav>`.

- active:

  If `TRUE`, mark the item as the current page (no link).

- href:

  Optional link target. Ignored when `active = TRUE`.

## Value

A breadcrumb `<nav>` tag.

## Examples

``` r
bs_breadcrumb(
  bs_breadcrumb_item("Home", href = "#"),
  bs_breadcrumb_item("Library", active = TRUE)
)
#> <nav aria-label="breadcrumb">
#>   <ol class="breadcrumb">
#>     <li class="breadcrumb-item">
#>       <a href="#">Home</a>
#>     </li>
#>     <li class="breadcrumb-item active" aria-current="page">Library</li>
#>   </ol>
#> </nav>
```
