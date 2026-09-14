# Bootstrap dropdown inside a nav or a navbar

The dropdown a designer draws in a navbar: an
`<li class="nav-item dropdown">` whose toggle is a `.nav-link`, not a
button.
[`bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md)
builds the standalone, button-triggered menu, which is invalid as a
direct child of the `<ul class="navbar-nav">` that
[`bs_navbar_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_navbar.md)
and
[`bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md)
produce, and renders as a grey button rather than a nav link.

## Usage

``` r
bs_nav_dropdown(
  label,
  ...,
  active = FALSE,
  disabled = FALSE,
  align = NULL,
  dark = FALSE,
  id = NULL,
  class = NULL
)
```

## Arguments

- label:

  Toggle text.

- ...:

  Menu content (unnamed) and named HTML attributes applied to the
  `<li>`.

- active:

  If `TRUE`, mark the toggle as the active page (`.active` and
  `aria-current="page"`).

- disabled:

  If `TRUE`, mark the toggle disabled.

- align:

  Menu alignment: `"end"`, or a named list per breakpoint (e.g.
  `list(lg = "end")`).

- dark:

  If `TRUE`, render a dark menu (`data-bs-theme="dark"`, the Bootstrap
  5.3 idiom).

- id:

  Optional dropdown id. Its open state is reported as `input$id`, and it
  can be driven with
  [`show_bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_dropdown.md)
  and friends.

- class:

  Extra classes for the `<li>`.

## Value

An `<li>` tag, ready to drop into
[`bs_navbar_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_navbar.md)
or
[`bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md).

## Details

Fill it with the same items as
[`bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md):
[`bs_dropdown_item()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md),
[`bs_dropdown_header()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md),
[`bs_dropdown_divider()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md),
[`bs_dropdown_text()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md).

## See also

[`bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_dropdown.md),
[`bs_navbar_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_navbar.md),
[`bs_nav()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav.md)

## Examples

``` r
bs_navbar_nav(
  bs_nav_item(bs_nav_link("Home", active = TRUE)),
  bs_nav_dropdown("More", bs_dropdown_item("Settings"))
)
#> <ul class="navbar-nav">
#>   <li class="nav-item">
#>     <a class="nav-link active" href="#" aria-current="page" data-value="Home">Home</a>
#>   </li>
#>   <li class="nav-item dropdown">
#>     <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">More</a>
#>     <ul class="dropdown-menu">
#>       <li>
#>         <a class="dropdown-item" href="#">Settings</a>
#>       </li>
#>     </ul>
#>   </li>
#> </ul>
```
