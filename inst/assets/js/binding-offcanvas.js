/* bootstrict offcanvas binding --------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Report whether the offcanvas is currently shown.
  bootstrict.eventBinding({
    name: "bootstrict.offcanvas",
    selector: ".offcanvas[data-bootstrict='offcanvas']",
    events: ["shown.bs.offcanvas", "hidden.bs.offcanvas"],
    getValue: function (el) {
      return el.classList.contains("show");
    }
  });

  // Server -> client: show / hide / toggle.
  bootstrict.addHandler("offcanvas.show", function (msg) {
    var el = document.getElementById(msg.id);
    if (el) bootstrict.bs("Offcanvas", el).show();
  });

  bootstrict.addHandler("offcanvas.hide", function (msg) {
    var el = document.getElementById(msg.id);
    if (el) bootstrict.bs("Offcanvas", el).hide();
  });

  bootstrict.addHandler("offcanvas.toggle", function (msg) {
    var el = document.getElementById(msg.id);
    if (el) bootstrict.bs("Offcanvas", el).toggle();
  });
})(window);
