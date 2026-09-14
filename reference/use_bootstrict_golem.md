# Scaffold a bootstrict app as a golem project hook

A
[`golem::create_golem()`](https://thinkr-open.github.io/golem/reference/create_golem.html)
`project_hook` that turns a freshly created golem skeleton into a
minimal bootstrict application:

## Usage

``` r
use_bootstrict_golem(path, package_name, ...)
```

## Arguments

- path:

  Path of the newly created golem project. Unused, kept for
  compatibility with the golem hook interface.

- package_name:

  Name of the package / application being created.

- ...:

  Reserved for compatibility with the golem hook interface.

## Value

Invisibly `NULL`. Called for its side effects on the project files.

## Details

- `R/app_ui.R` is rewritten to use
  [`bs_page()`](https://thinkr-open.github.io/bootstrict/reference/bs_page.md)
  and shows a "Hello world" inside a
  [`bs_container()`](https://thinkr-open.github.io/bootstrict/reference/bs_container.md).

- An (empty by default) `inst/app/www/_variables.scss` designer variable
  sheet is created and wired into
  [`bootstrict_theme()`](https://thinkr-open.github.io/bootstrict/reference/bootstrict_theme.md),
  so a designer can drop SCSS variables (`$name: value;`) in and have
  them picked up automatically.

golem sets the working directory to the new project before calling the
hook, so every path below is relative to the application root.

## Examples

``` r
if (interactive()) {
  golem::create_golem(
    "my.app",
    project_hook = bootstrict::use_bootstrict_golem
  )
}
```
