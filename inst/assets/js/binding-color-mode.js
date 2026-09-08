/* bootstrict colour mode ----------------------------------------------------
 *
 * Bootstrap 5.3 colour modes. Three things the attribute alone does not give:
 *
 *  - it belongs on <html>, not <body>: `color-scheme` is what tells the
 *    browser to paint scrollbars and native controls dark, and it only
 *    reaches them from the root element;
 *  - "auto" follows the OS, and a choice the user made has to outlive the
 *    reload, so it is kept in localStorage;
 *  - the resolved mode is reported as input$bootstrict_color_mode, so the
 *    server can render to match.
 * ------------------------------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  var STORE = "bootstrict-color-mode";
  var root = document.documentElement;

  function stored() {
    try {
      return window.localStorage.getItem(STORE);
    } catch (e) {
      // Private browsing, or storage disabled.
      return null;
    }
  }

  function remember(mode) {
    try {
      if (mode === null) {
        window.localStorage.removeItem(STORE);
      } else {
        window.localStorage.setItem(STORE, mode);
      }
    } catch (e) {
      /* nothing to do: the mode still applies for this page */
    }
  }

  function systemMode() {
    return window.matchMedia &&
      window.matchMedia("(prefers-color-scheme: dark)").matches
      ? "dark"
      : "light";
  }

  // The mode asked for, which may be "auto". Null when the app never asked
  // for one: it then keeps Bootstrap's default rather than following the OS
  // behind the author's back.
  function preferred() {
    return stored() || root.getAttribute("data-bootstrict-color-mode");
  }

  function resolve(mode) {
    return mode === "auto" ? systemMode() : mode;
  }

  function apply(mode) {
    var resolved = resolve(mode);
    root.setAttribute("data-bootstrict-color-mode", mode);
    root.setAttribute("data-bs-theme", resolved);
    // bs_page() sets the attribute on the body for the first paint; once the
    // root carries it, a second copy would only confuse a reader.
    if (document.body) document.body.removeAttribute("data-bs-theme");
    report(resolved);
  }

  function report(resolved) {
    if (window.Shiny && Shiny.setInputValue) {
      Shiny.setInputValue("bootstrict_color_mode", resolved);
    }
  }

  bootstrict.colorMode = { apply: apply, preferred: preferred };

  // Server -> client. "auto" hands control back to the OS and forgets the
  // stored choice.
  bootstrict.addHandler("colormode.set", function (msg) {
    if (["light", "dark", "auto"].indexOf(msg.mode) === -1) return;
    remember(msg.mode === "auto" ? null : msg.mode);
    apply(msg.mode);
  });

  var initial = preferred();
  if (initial) {
    apply(initial);
  } else {
    report(root.getAttribute("data-bs-theme") || "light");
  }

  if (window.matchMedia) {
    window
      .matchMedia("(prefers-color-scheme: dark)")
      .addEventListener("change", function () {
        if (preferred() === "auto") apply("auto");
      });
  }

  // Shiny is not connected yet when this file runs.
  $(document).on("shiny:connected", function () {
    report(resolve(preferred()));
  });
})(window);
