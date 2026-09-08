# layout markup is stable

    Code
      snap(bs_container("x"))
    Output
      <div class="container">x</div> 

---

    Code
      snap(bs_container("x", fluid = TRUE))
    Output
      <div class="container-fluid">x</div> 

---

    Code
      snap(bs_row(bs_col("a", width = 6), bs_col("b"), gutters = 3))
    Output
      <div class="row gx-3 gy-3">
        <div class="col-6">a</div>
        <div class="col">b</div>
      </div> 

---

    Code
      snap(bs_col("x", md = 6, lg = 4, offset = 2))
    Output
      <div class="col-md-6 col-lg-4 offset-2">x</div> 

---

    Code
      snap(bs_hstack("a", "b", gap = 3))
    Output
      <div class="hstack gap-3">
        a
        b
      </div> 

---

    Code
      snap(bs_vstack("a", "b", gap = 2))
    Output
      <div class="vstack gap-2">
        a
        b
      </div> 

# content markup is stable

    Code
      snap(bs_table(head(mtcars, 2)[, 1:2], striped = TRUE, hover = TRUE, caption = "Cars"))
    Output
      <table class="table table-striped table-hover">
        <caption>Cars</caption>
        <thead>
          <tr>
            <th scope="col"></th>
            <th scope="col">mpg</th>
            <th scope="col">cyl</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <th scope="row">Mazda RX4</th>
            <td>21</td>
            <td>6</td>
          </tr>
          <tr>
            <th scope="row">Mazda RX4 Wag</th>
            <td>21</td>
            <td>6</td>
          </tr>
        </tbody>
      </table> 

---

    Code
      snap(bs_table(data.frame(a = 1:2, b = c("x", "y"))))
    Output
      <table class="table">
        <thead>
          <tr>
            <th scope="col">a</th>
            <th scope="col">b</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>1</td>
            <td>x</td>
          </tr>
          <tr>
            <td>2</td>
            <td>y</td>
          </tr>
        </tbody>
      </table> 

---

    Code
      snap(bs_img("a.png", alt = "A", fluid = TRUE))
    Output
      <img src="a.png" alt="A" class="img-fluid"/> 

---

    Code
      snap(bs_figure(bs_figure_img("a.png", alt = "A"), bs_figure_caption("A caption")))
    Output
      <figure class="figure">
        <img src="a.png" alt="A" class="figure-img img-fluid rounded"/>
        <figcaption class="figure-caption">A caption</figcaption>
      </figure> 

---

    Code
      snap(bs_blockquote("Quote", footer = "Source"))
    Output
      <figure>
        <blockquote class="blockquote">Quote</blockquote>
        <figcaption class="blockquote-footer">Source</figcaption>
      </figure> 

---

    Code
      snap(bs_display_heading("Display", level = 3))
    Output
      <h3 class="display-3">Display</h3> 

---

    Code
      snap(bs_lead("Lead paragraph."))
    Output
      <p class="lead">Lead paragraph.</p> 

---

    Code
      snap(bs_list_unstyled("One", "Two"))
    Output
      <ul class="list-unstyled">
        <li>One</li>
        <li>Two</li>
      </ul> 

---

    Code
      snap(bs_list_inline("One", "Two"))
    Output
      <ul class="list-inline">
        <li class="list-inline-item">One</li>
        <li class="list-inline-item">Two</li>
      </ul> 

---

    Code
      snap(bs_icon_link("Icon link", href = "#", hover = TRUE))
    Output
      <a class="icon-link icon-link-hover" href="#">Icon link</a> 

---

    Code
      snap(bs_ratio("x", ratio = "16x9"))
    Output
      <div class="ratio ratio-16x9">x</div> 

---

    Code
      snap(bs_vr())
    Output
      <div class="vr"></div> 

---

    Code
      snap(bs_visually_hidden("Hidden"))
    Output
      <span class="visually-hidden">Hidden</span> 

# button markup is stable

    Code
      snap(bs_button("go", "Go", color = "primary"))
    Output
      <button id="go" class="btn btn-primary action-button" type="button">Go</button> 

---

    Code
      snap(bs_button("go", "Go", outline = TRUE, size = "lg"))
    Output
      <button id="go" class="btn btn-outline-primary btn-lg action-button" type="button">Go</button> 

---

    Code
      snap(bs_button("Link", href = "#", disabled = TRUE))
    Output
      <a id="Link" class="btn btn-primary action-button disabled" href="#" role="button" tabindex="-1" aria-disabled="true"></a> 

---

    Code
      snap(bs_button_group(bs_button("a", "A"), bs_button("b", "B"), size = "sm"))
    Output
      <div class="btn-group btn-group-sm" role="group">
        <button id="a" class="btn btn-primary action-button" type="button">A</button>
        <button id="b" class="btn btn-primary action-button" type="button">B</button>
      </div> 

---

    Code
      snap(bs_button_toolbar(bs_button_group(bs_button("a", "A"))))
    Output
      <div class="btn-toolbar" role="toolbar">
        <div class="btn-group" role="group">
          <button id="a" class="btn btn-primary action-button" type="button">A</button>
        </div>
      </div> 

---

    Code
      snap(bs_close_button())
    Output
      <button type="button" class="btn-close" aria-label="Close"></button> 

---

    Code
      snap(bs_download_button("dl", "Download", color = "success"))
    Output
      <a id="dl" href="" target="_blank" download aria-disabled="true" tabindex="-1" class="btn shiny-download-link disabled btn-success">Download</a> 

---

    Code
      snap(bs_download_link("dl", "Download"))
    Output
      <a aria-disabled="true" class="shiny-download-link disabled" download href="" id="dl" tabindex="-1" target="_blank">Download</a> 

# card markup is stable

    Code
      snap(bs_card(bs_card_header("Header"), bs_card_img("a.png", alt = "A"),
      bs_card_body(bs_card_title("Title"), bs_card_subtitle("Subtitle"), bs_card_text(
        "Body text."), bs_card_link("More", href = "#")), bs_card_footer("Footer")))
    Output
      <div class="card">
        <div class="card-header">Header</div>
        <img src="a.png" alt="A" class="card-img-top"/>
        <div class="card-body">
          <h5 class="card-title">Title</h5>
          <h6 class="card-subtitle mb-2 text-body-secondary">Subtitle</h6>
          <p class="card-text">Body text.</p>
          <a href="#" class="card-link">More</a>
        </div>
        <div class="card-footer">Footer</div>
      </div> 

---

    Code
      snap(bs_card_group(bs_card(bs_card_body("a"))))
    Output
      <div class="card-group">
        <div class="card">
          <div class="card-body">a</div>
        </div>
      </div> 

---

    Code
      snap(bs_card_img_overlay("over"))
    Output
      <div class="card-img-overlay">over</div> 

# feedback component markup is stable

    Code
      snap(bs_alert(bs_alert_heading("Heads up"), "Body", bs_alert_link("link", href = "#"),
      color = "warning", dismissible = TRUE))
    Output
      <div class="alert alert-warning alert-dismissible fade show" role="alert">
        <h4 class="alert-heading">Heads up</h4>
        Body
        <a href="#" class="alert-link">link</a>
        <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="alert"></button>
      </div> 

---

    Code
      snap(bs_badge("4", color = "danger", pill = TRUE))
    Output
      <span class="badge text-bg-danger rounded-pill">4</span> 

---

    Code
      snap(bs_progress(bs_progress_bar(40, color = "info")))
    Output
      <div class="progress" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100">
        <div class="progress-bar bg-info" style="width: 40%"></div>
      </div> 

---

    Code
      snap(bs_progress(bs_progress_bar(15), bs_progress_bar(30), height = "10px"))
    Output
      <div class="progress-stacked">
        <div class="progress" role="progressbar" aria-valuenow="15" aria-valuemin="0" aria-valuemax="100" style="width: 15%; height: 10px">
          <div class="progress-bar"></div>
        </div>
        <div class="progress" role="progressbar" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100" style="width: 30%; height: 10px">
          <div class="progress-bar"></div>
        </div>
      </div> 

---

    Code
      snap(bs_spinner(color = "primary", size = "sm"))
    Output
      <div class="spinner-border text-primary spinner-border-sm" role="status">
        <span class="visually-hidden">Loading...</span>
      </div> 

---

    Code
      snap(bs_placeholder_glow(bs_placeholder(width = 6)))
    Output
      <p class="placeholder-glow">
        <span class="placeholder col-6"></span>
      </p> 

---

    Code
      snap(bs_placeholder_wave(bs_placeholder(width = 4)))
    Output
      <p class="placeholder-wave">
        <span class="placeholder col-4"></span>
      </p> 

# interactive component markup is stable

    Code
      snap(bs_accordion("acc", bs_accordion_panel("One", "first", value = "one"),
      bs_accordion_panel("Two", "second", value = "two"), flush = TRUE))
    Output
      <div id="acc" class="accordion accordion-flush" data-bootstrict="accordion">
        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#acc-panel-1" aria-expanded="false" aria-controls="acc-panel-1">One</button>
          </h2>
          <div id="acc-panel-1" class="accordion-collapse collapse" data-value="one" data-bs-parent="#acc">
            <div class="accordion-body">first</div>
          </div>
        </div>
        <div class="accordion-item">
          <h2 class="accordion-header">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#acc-panel-2" aria-expanded="false" aria-controls="acc-panel-2">Two</button>
          </h2>
          <div id="acc-panel-2" class="accordion-collapse collapse" data-value="two" data-bs-parent="#acc">
            <div class="accordion-body">second</div>
          </div>
        </div>
      </div> 

---

    Code
      snap(bs_carousel("car", bs_carousel_item(bs_img("a.png", alt = "A"), caption = "One",
      value = "s1"), bs_carousel_item(bs_img("b.png", alt = "B"), value = "s2"),
      indicators = TRUE))
    Output
      <div id="car" class="carousel slide" data-bootstrict="carousel" data-bs-ride="carousel">
        <div class="carousel-indicators">
          <button type="button" data-bs-target="#car" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
          <button type="button" data-bs-target="#car" data-bs-slide-to="1" aria-label="Slide 2"></button>
        </div>
        <div class="carousel-inner">
          <div class="carousel-item active" value="s1">
            <img src="a.png" alt="A"/>
            <div class="carousel-caption d-none d-md-block">One</div>
          </div>
          <div class="carousel-item" value="s2">
            <img src="b.png" alt="B"/>
          </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#car" data-bs-slide="prev">
          <span class="carousel-control-prev-icon" aria-hidden="true"></span>
          <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#car" data-bs-slide="next">
          <span class="carousel-control-next-icon" aria-hidden="true"></span>
          <span class="visually-hidden">Next</span>
        </button>
      </div> 

---

    Code
      snap(bs_collapse("coll", "Body"))
    Output
      <div id="coll" class="collapse" data-bootstrict="collapse">Body</div> 

---

    Code
      snap(bs_collapse_trigger("coll", "Toggle"))
    Output
      <button class="btn collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#coll" aria-expanded="false" aria-controls="coll">Toggle</button> 

---

    Code
      snap(bs_list_group("lg", bs_list_group_item("A", value = "a", action = TRUE),
      bs_list_group_item("B", value = "b", action = TRUE, active = TRUE), flush = TRUE))
    Output
      <div class="list-group list-group-flush" id="lg" data-bootstrict="list-group">
        <button type="button" class="list-group-item list-group-item-action" data-value="a">A</button>
        <button type="button" class="list-group-item list-group-item-action active" data-value="b" aria-current="true">B</button>
      </div> 

# navigation markup is stable

    Code
      snap(bs_nav(bs_nav_item(bs_nav_link("Home", active = TRUE)), bs_nav_item(
        bs_nav_link("Away", disabled = TRUE)), type = "underline"))
    Output
      <ul class="nav nav-underline">
        <li class="nav-item">
          <a class="nav-link active" href="#" aria-current="page">Home</a>
        </li>
        <li class="nav-item">
          <a class="nav-link disabled" href="#" aria-disabled="true">Away</a>
        </li>
      </ul> 

---

    Code
      snap(bs_tabset("tabs", bs_tab_panel("One", "first", value = "one"),
      bs_tab_panel("Two", "second", value = "two")))
    Output
      <div class="bootstrict-tabset">
        <ul class="nav nav-tabs" role="tablist" id="tabs" data-bootstrict="tabset">
          <li class="nav-item" role="presentation">
            <button class="nav-link active" id="tabs-tab-1" data-bs-toggle="tab" data-bs-target="#tabs-pane-1" type="button" role="tab" aria-controls="tabs-pane-1" aria-selected="true" data-value="one">One</button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="tabs-tab-2" data-bs-toggle="tab" data-bs-target="#tabs-pane-2" type="button" role="tab" aria-controls="tabs-pane-2" aria-selected="false" data-value="two">Two</button>
          </li>
        </ul>
        <div class="tab-content">
          <div class="tab-pane fade show active" id="tabs-pane-1" role="tabpanel" aria-labelledby="tabs-tab-1" tabindex="0" data-value="one">first</div>
          <div class="tab-pane fade" id="tabs-pane-2" role="tabpanel" aria-labelledby="tabs-tab-2" tabindex="0" data-value="two">second</div>
        </div>
      </div> 

---

    Code
      snap(bs_navbar(id = "nav", brand = bs_navbar_brand("Brand", href = "/"),
      bs_navbar_nav(bs_nav_item(bs_nav_link("Home", active = TRUE)), bs_nav_dropdown(
        "More", bs_dropdown_item("Settings"))), bs_navbar_text("Text"), bg = "primary",
      theme = "dark"))
    Output
      <nav id="nav" class="navbar navbar-expand-lg bg-primary" data-bs-theme="dark">
        <div class="container-fluid">
          <a class="navbar-brand" href="/">Brand</a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav-collapse" aria-controls="nav-collapse" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="nav-collapse">
            <ul class="navbar-nav">
              <li class="nav-item">
                <a class="nav-link active" href="#" aria-current="page">Home</a>
              </li>
              <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">More</a>
                <ul class="dropdown-menu">
                  <li>
                    <a class="dropdown-item" href="#">Settings</a>
                  </li>
                </ul>
              </li>
            </ul>
            <span class="navbar-text">Text</span>
          </div>
        </div>
      </nav> 

---

    Code
      snap(bs_breadcrumb(bs_breadcrumb_item("Home", href = "/"), bs_breadcrumb_item(
        "Here", active = TRUE)))
    Output
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
          <li class="breadcrumb-item">
            <a href="/">Home</a>
          </li>
          <li class="breadcrumb-item active" aria-current="page">Here</li>
        </ol>
      </nav> 

---

    Code
      snap(bs_pagination(bs_page_item("1", href = "#", active = TRUE), bs_page_item(
        "2", href = "#")))
    Output
      <nav aria-label="Page navigation">
        <ul class="pagination">
          <li class="page-item active">
            <a class="page-link" href="#" aria-current="page">1</a>
          </li>
          <li class="page-item">
            <a class="page-link" href="#">2</a>
          </li>
        </ul>
      </nav> 

---

    Code
      snap(bs_pagination_numbered(3, current = 2))
    Output
      <nav aria-label="Page navigation">
        <ul class="pagination">
          <li class="page-item">
            <a class="page-link" href="#">Previous</a>
          </li>
          <li class="page-item">
            <a class="page-link" href="#">1</a>
          </li>
          <li class="page-item active">
            <a class="page-link" href="#" aria-current="page">2</a>
          </li>
          <li class="page-item">
            <a class="page-link" href="#">3</a>
          </li>
          <li class="page-item">
            <a class="page-link" href="#">Next</a>
          </li>
        </ul>
      </nav> 

---

    Code
      snap(bs_dropdown("Menu", bs_dropdown_header("Actions"), bs_dropdown_item("Edit",
        id = "edit"), bs_dropdown_divider(), bs_dropdown_text("Signed in"), align = "end"))
    Output
      <div class="dropdown">
        <button type="button" class="btn btn-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">Menu</button>
        <ul class="dropdown-menu dropdown-menu-end">
          <li>
            <h6 class="dropdown-header">Actions</h6>
          </li>
          <li>
            <a id="edit" class="dropdown-item action-button" href="#">Edit</a>
          </li>
          <li>
            <hr class="dropdown-divider"/>
          </li>
          <li>
            <span class="dropdown-item-text">Signed in</span>
          </li>
        </ul>
      </div> 

---

    Code
      snap(bs_nav_dropdown("More", bs_dropdown_item("Settings")))
    Output
      <li class="nav-item dropdown">
        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">More</a>
        <ul class="dropdown-menu">
          <li>
            <a class="dropdown-item" href="#">Settings</a>
          </li>
        </ul>
      </li> 

# overlay markup is stable

    Code
      snap(bs_modal("m", "Body", title = "Title", footer = bs_button("ok", "OK"),
      size = "lg", centered = TRUE))
    Output
      <div id="m" class="modal fade" tabindex="-1" aria-hidden="true" aria-labelledby="m-title" data-bootstrict="modal">
        <div class="modal-dialog modal-lg modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-header">
              <h1 class="modal-title fs-5" id="m-title">Title</h1>
              <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">Body</div>
            <div class="modal-footer">
              <button id="ok" class="btn btn-primary action-button" type="button">OK</button>
            </div>
          </div>
        </div>
      </div> 

---

    Code
      snap(bs_modal("m2", bs_modal_header(bs_modal_title("Title")), bs_modal_body(
        "Body"), bs_modal_footer("Footer")))
    Output
      <div id="m2" class="modal fade" tabindex="-1" aria-hidden="true" data-bootstrict="modal">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h1 class="modal-title fs-5">Title</h1>
              <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">Body</div>
            <div class="modal-footer">Footer</div>
          </div>
        </div>
      </div> 

---

    Code
      snap(bs_modal_trigger("m", "Open"))
    Output
      <button class="btn btn-primary" type="button" data-bs-toggle="modal" data-bs-target="#m">Open</button> 

---

    Code
      snap(bs_offcanvas("oc", "Body", title = "Filters"))
    Output
      <div class="offcanvas offcanvas-start" tabindex="-1" id="oc" aria-labelledby="oc-title" data-bootstrict="offcanvas">
        <div class="offcanvas-header">
          <h5 class="offcanvas-title" id="oc-title">Filters</h5>
          <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="offcanvas" data-bs-target="#oc"></button>
        </div>
        <div class="offcanvas-body">Body</div>
      </div> 

---

    Code
      snap(bs_offcanvas("ocr", "Body", title = "Filters", responsive = "lg",
        placement = "end"))
    Output
      <div class="offcanvas-lg offcanvas-end" tabindex="-1" id="ocr" aria-labelledby="ocr-title" data-bootstrict="offcanvas">
        <div class="offcanvas-header">
          <h5 class="offcanvas-title" id="ocr-title">Filters</h5>
          <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="offcanvas" data-bs-target="#ocr"></button>
        </div>
        <div class="offcanvas-body">Body</div>
      </div> 

---

    Code
      snap(bs_offcanvas_trigger("oc", "Open"))
    Output
      <button class="btn btn-primary" type="button" data-bs-toggle="offcanvas" data-bs-target="#oc" aria-controls="oc">Open</button> 

---

    Code
      snap(bs_toast("t", "Body", title = "Toast"))
    Output
      <div id="t" class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-bootstrict="toast" data-bs-delay="5000">
        <div class="toast-header">
          <strong class="me-auto">Toast</strong>
          <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="toast"></button>
        </div>
        <div class="toast-body">Body</div>
      </div> 

---

    Code
      snap(bs_toast_container(bs_toast("t", "Body")))
    Output
      <div class="toast-container position-fixed p-3 top-0 end-0">
        <div id="t" class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-bootstrict="toast" data-bs-delay="5000">
          <div class="toast-body">Body</div>
        </div>
      </div> 

---

    Code
      snap(bs_tooltip(bs_button("b", "B"), "Tip"))
    Output
      <button id="b" class="btn btn-primary action-button" type="button" data-bs-toggle="tooltip" data-bs-title="Tip" data-bs-placement="top" data-bootstrict-tip="tooltip">B</button> 

---

    Code
      snap(bs_popover(bs_button("b", "B"), "Content", title = "Title"))
    Output
      <button id="b" class="btn btn-primary action-button" type="button" data-bs-toggle="popover" data-bs-content="Content" data-bs-title="Title" data-bs-placement="right" data-bs-trigger="click" data-bootstrict-tip="popover">B</button> 

---

    Code
      snap(bs_scrollspy("Body", target = "nav", id = "spy"))
    Output
      <div id="spy" data-bs-spy="scroll" data-bs-target="#nav" data-bs-smooth-scroll="true" tabindex="0" data-bootstrict="scrollspy">Body</div> 

