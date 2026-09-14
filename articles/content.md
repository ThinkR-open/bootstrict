# Content: tables, media and typography

``` r

library(shiny)
library(bootstrict)
```

These are the static “content” widgets: tables, images and figures,
blockquotes, display typography, and lists — plus a few small helpers.
None report state to the server; they are pure UI.

## Tables

[`bs_table()`](https://thinkr-open.github.io/bootstrict/reference/bs_table.md)
renders a faithful Bootstrap `<table class="table">`. Pass a data frame
or matrix as the first argument and it builds the header and body for
you; pass tag children instead to hand-build the rows.

``` r

bs_table(
  data = NULL,
  ...,                 # manual children when `data` is NULL
  striped = FALSE,     # TRUE / "rows", or "columns"
  bordered = FALSE,    # borders on all sides
  borderless = FALSE,  # remove all borders
  hover = FALSE,       # hover highlight
  small = FALSE,       # condensed padding
  variant = NULL,      # a theme colour for the whole table
  responsive = FALSE,  # TRUE, or a breakpoint "sm"/"md"/… for horizontal scroll
  align = NULL,        # vertical alignment: "middle"/"top"/"bottom"
  caption = NULL,
  caption_top = FALSE, # put the caption above the table
  head_variant = NULL, # a theme colour for the <thead>
  group_divider = FALSE, # thicker border under the header
  row_variant = NULL,  # per-row theme colour, recycled; NA leaves a row plain
  rownames = NULL,     # row names as the reference <th scope="row">
  class = NULL
)
```

The most common form — a styled data-frame table:

``` r

bs_table(head(mtcars), striped = TRUE, hover = TRUE)
```

The accented variants from the Bootstrap tables page are arguments
rather than classes you have to remember, and they compose:

``` r

bs_table(
  head(mtcars, 4),
  head_variant = "dark",
  group_divider = TRUE,
  row_variant = c(NA, "success", NA, "danger"),
  caption = "Four cars",
  caption_top = TRUE
)
```

`row_variant` is recycled to the number of rows, so a single value
colours them all, and `NA` leaves a row alone. `"active"` is accepted
alongside the theme colours.

`responsive = TRUE` wraps the table so it scrolls horizontally on narrow
screens (or pass a breakpoint to only do so below it):

``` r

bs_table(
  df,
  striped = TRUE,
  small = TRUE,
  responsive = TRUE,
  caption = "24 matching events"
)
```

## Images

[`bs_img()`](https://thinkr-open.github.io/bootstrict/reference/bs_img.md)
is a Bootstrap `<img>` with the usual responsive utilities.

``` r

bs_img(
  src,
  ...,
  fluid = FALSE,      # .img-fluid — scale down to fit the parent
  thumbnail = FALSE,  # .img-thumbnail — rounded bordered frame
  rounded = FALSE,    # rounded corners
  object_fit = NULL,  # "contain"/"cover"/"fill"/"scale"/"none" (5.3)
  alt = NULL,
  class = NULL
)
```

``` r

bs_img("logo.png", alt = "Logo", fluid = TRUE)
```

## Figures

A figure groups an image with a caption. Use
[`bs_figure_img()`](https://thinkr-open.github.io/bootstrict/reference/bs_figure.md)
and
[`bs_figure_caption()`](https://thinkr-open.github.io/bootstrict/reference/bs_figure.md)
inside
[`bs_figure()`](https://thinkr-open.github.io/bootstrict/reference/bs_figure.md):

``` r

bs_figure(
  bs_figure_img("photo.jpg", alt = "A photo"),
  bs_figure_caption("A caption for the image.")
)
```

## Blockquotes

[`bs_blockquote()`](https://thinkr-open.github.io/bootstrict/reference/bs_blockquote.md)
renders a Bootstrap `.blockquote` inside a `<figure>`, with an optional
attribution `footer`:

``` r

bs_blockquote(
  "The data set gives the locations of 1000 seismic events of MB > 4.0.",
  footer = "R datasets documentation"
)
```

## Display typography

Two constructors cover Bootstrap’s opinionated typographic accents.

[`bs_display_heading()`](https://thinkr-open.github.io/bootstrict/reference/bs_display_heading.md)
is a large, prominent heading; `level` (1–6) sets both the size
(`.display-{level}`) and the heading element:

``` r

bs_display_heading("Seismic activity, Fiji region", level = 2)
```

[`bs_lead()`](https://thinkr-open.github.io/bootstrict/reference/bs_lead.md)
is a standout opening paragraph (`.lead`):

``` r

bs_lead("1,000 events of magnitude 4.0 and above, recorded since 1964.")
```

## Lists

[`bs_list_unstyled()`](https://thinkr-open.github.io/bootstrict/reference/bs_list_unstyled.md)
strips the default list styling; each unnamed argument becomes an
`<li>`.
[`bs_list_inline()`](https://thinkr-open.github.io/bootstrict/reference/bs_list_unstyled.md)
lays the items out horizontally.

``` r

bs_list_unstyled("First", "Second", "Third")
bs_list_inline("One", "Two", "Three")
```

You can also pass explicit `tags$li()` children when an item needs
richer content:

``` r

bs_list_unstyled(
  tags$li(tags$code("bootstrict_theme()"), " — the designer's sheet is the theme"),
  tags$li(tags$code("bs_offcanvas()"), " — the filter drawer")
)
```

(For an interactive, selectable list, use
[`bs_list_group()`](https://thinkr-open.github.io/bootstrict/reference/bs_list_group.md)
— see
[Components](https://thinkr-open.github.io/bootstrict/articles/components.md).)

## Small helpers

A handful of one-off utilities round out the content toolkit:

- **[`bs_icon_link()`](https://thinkr-open.github.io/bootstrict/reference/bs_icon_link.md)**
  — the Bootstrap 5.3 icon-link: an inline-flex `<a>` pairing an icon
  with text. `hover = TRUE` nudges the icon on hover.

  ``` r

  bs_icon_link("Documentation", href = "#")
  ```

- **[`bs_ratio()`](https://thinkr-open.github.io/bootstrict/reference/bs_ratio.md)**
  — wraps an embedded element (an `<iframe>`, a video) so it keeps a
  fixed aspect ratio. `ratio` is `"1x1"`, `"4x3"`, `"16x9"` or `"21x9"`.

  ``` r

  bs_ratio(tags$iframe(src = "https://example.com"), ratio = "16x9")
  ```

- **[`bs_vr()`](https://thinkr-open.github.io/bootstrict/reference/bs_vr.md)**
  — a vertical divider, the vertical counterpart of `<hr>`. Handy
  between items in an
  [`bs_hstack()`](https://thinkr-open.github.io/bootstrict/reference/bs_hstack.md).

  ``` r

  bs_hstack(gap = 2, "Left", bs_vr(), "Right")
  ```

- **[`bs_visually_hidden()`](https://thinkr-open.github.io/bootstrict/reference/bs_visually_hidden.md)**
  — content available to assistive technology but hidden from sighted
  users.

  ``` r

  bs_visually_hidden("Loading, please wait")
  ```
