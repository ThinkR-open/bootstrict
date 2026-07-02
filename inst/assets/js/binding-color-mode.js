/* bootstrict colour-mode handler --------------------------------------------
 *
 * Bootstrap 5.3 colour modes: set_bs_color_mode() switches data-bs-theme on
 * the page body (the same element bs_page(color_mode =) initialises), so the
 * whole app flips between light and dark.
 * ------------------------------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  bootstrict.addHandler("colormode.set", function (msg) {
    if (msg.mode !== "light" && msg.mode !== "dark") return;
    document.body.setAttribute("data-bs-theme", msg.mode);
  });
})(window);
