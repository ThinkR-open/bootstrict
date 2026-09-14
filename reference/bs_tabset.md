# Bootstrap tabset

An interactive set of tabbed panels. The `data-value` of the currently
shown panel is reported to the server as `input$id`, and the active tab
can be driven server-side with
[`update_bs_tabset()`](https://thinkr-open.github.io/bootstrict/reference/update_bs_tabset.md).

## Usage

``` r
bs_tabset(
  id,
  ...,
  type = "tabs",
  selected = NULL,
  fill = FALSE,
  justified = FALSE,
  vertical = FALSE,
  class = NULL
)

bs_tab_panel(title, ..., value = NULL, icon = NULL, class = NULL)
```

## Arguments

- id:

  Tabset id; the active panel value is available as `input$id`.

- ...:

  Panels built with `bs_tab_panel()`.

- type:

  Visual style: `"tabs"` (default), `"pills"` or `"underline"`
  (Bootstrap 5.3).

- selected:

  Value of the panel shown initially (defaults to the first).

- fill:

  If `TRUE`, tabs expand to fill available width (`.nav-fill`).

- justified:

  If `TRUE`, tabs get equal width (`.nav-justified`).

- vertical:

  If `TRUE`, lay tabs out vertically beside the content.

- class:

  Extra classes for the wrapper.

- title:

  Tab label content.

- value:

  Panel identifier reported to the server (defaults to `title`).

- icon:

  Optional icon placed before the title.

## Value

A tabset tag.

## Examples

``` r
bs_tabset(
  "tabs",
  bs_tab_panel("Home", "Home content", value = "home"),
  bs_tab_panel("Profile", "Profile content", value = "profile"),
  selected = "profile"
)
#> <div class="bootstrict-tabset">
#>   <ul class="nav nav-tabs" role="tablist" id="tabs" data-bootstrict="tabset">
#>     <li class="nav-item" role="presentation">
#>       <button class="nav-link" id="tabs-tab-1" data-bs-toggle="tab" data-bs-target="#tabs-pane-1" type="button" role="tab" aria-controls="tabs-pane-1" aria-selected="false" data-value="home">Home</button>
#>     </li>
#>     <li class="nav-item" role="presentation">
#>       <button class="nav-link active" id="tabs-tab-2" data-bs-toggle="tab" data-bs-target="#tabs-pane-2" type="button" role="tab" aria-controls="tabs-pane-2" aria-selected="true" data-value="profile">Profile</button>
#>     </li>
#>   </ul>
#>   <div class="tab-content">
#>     <div class="tab-pane fade" id="tabs-pane-1" role="tabpanel" aria-labelledby="tabs-tab-1" tabindex="0" data-value="home">Home content</div>
#>     <div class="tab-pane fade show active" id="tabs-pane-2" role="tabpanel" aria-labelledby="tabs-tab-2" tabindex="0" data-value="profile">Profile content</div>
#>   </div>
#> </div>
```
