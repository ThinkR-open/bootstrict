test_that("bs_pagination renders nav > ul.pagination with aria-label", {
  html <- as.character(
    bs_pagination(
      bs_page_item(
        "1",
        active = TRUE
      ),
      bs_page_item(
        "2"
      ),
      label = "Pager"
    )
  )

  expect_match(
    html,
    "<nav"
  )
  expect_match(
    html,
    "aria-label=\"Pager\""
  )
  expect_match(
    html,
    "<ul[^>]*class=\"pagination\""
  )
  expect_match(
    html,
    "page-item"
  )
})

test_that("bs_pagination size maps to .pagination-{sm,lg}", {
  expect_match(
    as.character(bs_pagination(
      bs_page_item(
        "1"
      ),
      size = "sm"
    )),
    "pagination-sm"
  )
  expect_match(
    as.character(bs_pagination(
      bs_page_item(
        "1"
      ),
      size = "lg"
    )),
    "pagination-lg"
  )
})

test_that("bs_pagination align maps to .justify-content-*", {
  expect_match(
    as.character(bs_pagination(
      bs_page_item(
        "1"
      ),
      align = "center"
    )),
    "justify-content-center"
  )
  expect_match(
    as.character(bs_pagination(
      bs_page_item(
        "1"
      ),
      align = "end"
    )),
    "justify-content-end"
  )
})

test_that("bs_pagination rejects invalid size / align", {
  expect_error(bs_pagination(
    bs_page_item(
      "1"
    ),
    size = "huge"
  ))
  expect_error(bs_pagination(
    bs_page_item(
      "1"
    ),
    align = "middle"
  ))
})

test_that("bs_pagination forwards extra class and named attributes to ul", {
  html <- as.character(
    bs_pagination(
      bs_page_item(
        "1"
      ),
      class = "my-pager",
      id = "pg"
    )
  )
  expect_match(
    html,
    "my-pager"
  )
  expect_match(
    html,
    "id=\"pg\""
  )
})

test_that("bs_page_item renders li.page-item > a.page-link with href", {
  html <- as.character(bs_page_item(
    "3",
    href = "/page/3"
  ))
  expect_match(
    html,
    "<li[^>]*class=\"page-item\""
  )
  expect_match(
    html,
    "<a[^>]*class=\"page-link\""
  )
  expect_match(
    html,
    "href=\"/page/3\""
  )
  expect_match(
    html,
    ">3<"
  )
})

test_that("bs_page_item active adds .active and aria-current", {
  html <- as.character(bs_page_item(
    "1",
    active = TRUE
  ))
  expect_match(
    html,
    "page-item active"
  )
  expect_match(
    html,
    "aria-current=\"page\""
  )
})

test_that("bs_page_item disabled adds .disabled, tabindex and aria-disabled", {
  html <- as.character(bs_page_item(
    "1",
    disabled = TRUE
  ))
  expect_match(
    html,
    "disabled"
  )
  expect_match(
    html,
    "tabindex=\"-1\""
  )
  expect_match(
    html,
    "aria-disabled=\"true\""
  )
})

test_that("bs_page_item without active/disabled omits those attributes", {
  html <- as.character(bs_page_item(
    "1"
  ))
  expect_false(grepl(
    "aria-current",
    html
  ))
  expect_false(grepl(
    "aria-disabled",
    html
  ))
  expect_match(
    html,
    "href=\"#\""
  )
})

test_that("bs_pagination_numbered builds prev + 1..n + next", {
  html <- as.character(bs_pagination_numbered(
    3,
    current = 2
  ))

  expect_match(
    html,
    "Previous"
  )
  expect_match(
    html,
    "Next"
  )
  expect_match(
    html,
    ">1<"
  )
  expect_match(
    html,
    ">2<"
  )
  expect_match(
    html,
    ">3<"
  )
  # current page (2) is active
  expect_match(
    html,
    "page-item active"
  )
})

test_that("bs_pagination_numbered disables prev on first / next on last page", {
  first <- as.character(bs_pagination_numbered(
    3,
    current = 1
  ))
  last <- as.character(bs_pagination_numbered(
    3,
    current = 3
  ))

  expect_match(
    first,
    "aria-disabled=\"true\""
  )
  expect_match(
    last,
    "aria-disabled=\"true\""
  )
})

test_that("bs_pagination_numbered uses href_template for links", {
  html <- as.character(
    bs_pagination_numbered(
      2,
      current = 1,
      href_template = "?page=%d"
    )
  )
  expect_match(
    html,
    "href=\"\\?page=1\""
  )
  expect_match(
    html,
    "href=\"\\?page=2\""
  )
})

test_that("bs_pagination_numbered forwards size and align", {
  html <- as.character(
    bs_pagination_numbered(
      2,
      current = 1,
      size = "lg",
      align = "center"
    )
  )
  expect_match(
    html,
    "pagination-lg"
  )
  expect_match(
    html,
    "justify-content-center"
  )
})

test_that("bs_pagination_numbered rejects non-positive n", {
  expect_error(bs_pagination_numbered(
    0
  ))
})

test_that("bs_pagination attaches the bootstrict dependency", {
  tag <- bs_pagination(bs_page_item(
    "1"
  ))
  deps <- htmltools::findDependencies(
    tag
  )
  expect_true(any(vapply(
    deps,
    function(
      d
    )
      d$name ==
        "bootstrict",
    logical(
      1
    )
  )))
})

test_that("bs_pagination reports its active page only when given an id", {
  out <- as.character(bs_pagination(
    bs_page_item(
      "1",
      active = TRUE
    ),
    bs_page_item(
      "2"
    ),
    id = "pg"
  ))
  expect_match(
    out,
    "id=\"pg\" data-bootstrict=\"pagination\""
  )
  expect_match(
    out,
    "<li data-value=\"1\" class=\"page-item active\">"
  )
  expect_no_match(
    as.character(bs_pagination(bs_page_item(
      "1"
    ))),
    "data-bootstrict=",
    fixed = TRUE
  )
})

test_that("a numbered pager numbers its pages and marks its arrows", {
  out <- as.character(bs_pagination_numbered(
    3,
    current = 2,
    id = "pg"
  ))
  expect_match(
    out,
    "data-value=\"2\" class=\"page-item active\""
  )
  # The arrows step through the pages instead of being a page of their own,
  # so they carry no value.
  expect_match(
    out,
    "data-bootstrict-step=\"prev\""
  )
  expect_match(
    out,
    "data-bootstrict-step=\"next\""
  )
  expect_no_match(
    out,
    "data-value=\"Previous\"",
    fixed = TRUE
  )
  expect_no_match(
    out,
    "data-value=\"Next\"",
    fixed = TRUE
  )
})

test_that("update_bs_pagination coerces and dispatches", {
  store <- NULL
  session <- list(
    sendCustomMessage = function(
      type,
      message
    ) {
      store <<- message
      invisible()
    },
    ns = function(
      x
    )
      paste0(
        "mod-",
        x
      )
  )
  update_bs_pagination(
    "pg",
    selected = 3,
    session = session
  )
  expect_equal(
    store$method,
    "pagination.update"
  )
  expect_equal(
    store$id,
    "mod-pg"
  )
  # Page values reach the DOM as strings.
  expect_equal(
    store$selected,
    "3"
  )
})
