# Bootstrap dropdown

A toggleable menu of links, headers and dividers. Compose the menu with
`bs_dropdown_item()`, `bs_dropdown_divider()`, `bs_dropdown_header()`
and `bs_dropdown_text()`. Bootstrap drives the toggle; give an item an
`id` to wire it as a Shiny action button (`input$id`).

## Usage

``` r
bs_dropdown(
  label,
  ...,
  id = NULL,
  color = "secondary",
  outline = FALSE,
  size = NULL,
  split = FALSE,
  direction = "down",
  dark = FALSE,
  align = NULL,
  auto_close = TRUE,
  offset = NULL,
  reference = NULL,
  class = NULL
)

bs_dropdown_item(
  ...,
  id = NULL,
  href = "#",
  active = FALSE,
  disabled = FALSE,
  class = NULL
)

bs_dropdown_divider(class = NULL)

bs_dropdown_header(..., level = 6, class = NULL)

bs_dropdown_text(..., class = NULL)
```

## Arguments

- label:

  Toggle button label (text or tags).

- ...:

  Menu contents (dropdown items, dividers, headers, text) and named HTML
  attributes (forwarded to the wrapper).

- id:

  Optional input id. When set, the item becomes a Shiny action button
  and its click count is reported as `input$id`.

- color:

  Toggle button theme colour, one of the Bootstrap theme colours or
  `"link"`.

- outline:

  If `TRUE`, an outline toggle button (`.btn-outline-*`).

- size:

  Toggle button size: `"sm"` or `"lg"`.

- split:

  If `TRUE`, render a split button (a normal action button plus a
  separate toggle caret).

- direction:

  Menu drop direction: `"down"`, `"up"`, `"end"` or `"start"`.

- dark:

  If `TRUE`, a dark dropdown via `data-bs-theme="dark"` on the wrapper
  (the Bootstrap 5.3 idiom; `.dropdown-menu-dark` is deprecated).

- align:

  Menu alignment. `"end"` right-aligns the menu (`.dropdown-menu-end`);
  a named list such as `list(lg = "end")` produces a responsive
  alignment (`.dropdown-menu-lg-end`).

- auto_close:

  When the menu closes on its own: `TRUE` (the default, inside or
  outside), `"inside"`, `"outside"`, or `FALSE` for manual only.

- offset:

  Menu offset from its toggle, as `"x,y"` in pixels.

- reference:

  What the menu is positioned against: `"toggle"` (the default),
  `"parent"`, or a CSS selector.

  Bootstrap reads all three from the *toggle*, not from the wrapper,
  which is why they are arguments rather than something to pass through
  `...`.

- class:

  Extra classes for the wrapper.

- href:

  Link target.

- active:

  If `TRUE`, mark the item active (`.active`).

- disabled:

  If `TRUE`, mark the item disabled (`.disabled`).

- level:

  Heading level (1-6) for the dropdown header.

## Value

A dropdown tag.

## Details

Give the dropdown itself an `id` and its open state is reported as
`input$id` (`TRUE` while the menu is open), and it can be driven from
the server with
[`show_bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_dropdown.md),
[`hide_bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_dropdown.md)
and
[`toggle_bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_dropdown.md).

## See also

[`show_bs_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/show_bs_dropdown.md),
[`bs_nav_dropdown()`](https://thinkr-open.github.io/bootstrict/reference/bs_nav_dropdown.md)

## Examples

``` r
bs_dropdown("Menu", bs_dropdown_item("Action", id = "act"))
#> <div class="dropdown">
#>   <button type="button" class="btn btn-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">Menu</button>
#>   <ul class="dropdown-menu">
#>     <li>
#>       <a id="act" class="dropdown-item action-button" href="#">Action</a>
#>     </li>
#>   </ul>
#> </div>
bs_dropdown(
  "Menu",
  bs_dropdown_header("Actions"),
  bs_dropdown_item("Edit", id = "edit"),
  bs_dropdown_divider(),
  bs_dropdown_text("Signed in as Colin")
)
#> <div class="dropdown">
#>   <button type="button" class="btn btn-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">Menu</button>
#>   <ul class="dropdown-menu">
#>     <li>
#>       <h6 class="dropdown-header">Actions</h6>
#>     </li>
#>     <li>
#>       <a id="edit" class="dropdown-item action-button" href="#">Edit</a>
#>     </li>
#>     <li>
#>       <hr class="dropdown-divider"/>
#>     </li>
#>     <li>
#>       <span class="dropdown-item-text">Signed in as Colin</span>
#>     </li>
#>   </ul>
#> </div>
```
