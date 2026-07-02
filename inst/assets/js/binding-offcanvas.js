/* bootstrict offcanvas binding --------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Report whether the offcanvas is currently shown. The selector matches on
  // the data attribute only: a responsive offcanvas has class
  // `.offcanvas-{bp}` *instead of* `.offcanvas`, so selecting on `.offcanvas`
  // would never bind it. Above its breakpoint a responsive offcanvas is shown
  // inline without `.show` — its computed position is no longer fixed.
  bootstrict.eventBinding({
    name: "bootstrict.offcanvas",
    selector: "[data-bootstrict='offcanvas']",
    events: ["shown.bs.offcanvas", "hidden.bs.offcanvas"],
    getValue: function (el) {
      if (el.classList.contains("show")) return true;
      return window.getComputedStyle(el).position !== "fixed";
    },
    unsubscribe: function (el) {
      if (window.bootstrap && window.bootstrap.Offcanvas) {
        var inst = window.bootstrap.Offcanvas.getInstance(el);
        if (inst) {
          try {
            inst.hide();
            inst.dispose();
          } catch (e) {
            /* mid-transition disposal is best-effort */
          }
        }
      }
    }
  });

  // Server -> client: show / hide / toggle.
  bootstrict.addHandler("offcanvas.show", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return bootstrict.missing("offcanvas.show", msg.id);
    var inst = bootstrict.bs("Offcanvas", el);
    if (inst) inst.show();
  });

  bootstrict.addHandler("offcanvas.hide", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return bootstrict.missing("offcanvas.hide", msg.id);
    var inst = bootstrict.bs("Offcanvas", el);
    if (inst) inst.hide();
  });

  bootstrict.addHandler("offcanvas.toggle", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return bootstrict.missing("offcanvas.toggle", msg.id);
    var inst = bootstrict.bs("Offcanvas", el);
    if (inst) inst.toggle();
  });
})(window);
