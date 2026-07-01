/* bootstrict tabset binding ------------------------------------------------ */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Report the data-value of the currently active tab.
  bootstrict.eventBinding({
    name: "bootstrict.tabset",
    selector: ".nav[data-bootstrict='tabset']",
    events: ["shown.bs.tab"],
    getValue: function (el) {
      var active = el.querySelector(".nav-link.active");
      return active ? active.getAttribute("data-value") : null;
    }
  });

  // Server -> client: show a tab by value.
  bootstrict.addHandler("tabset.update", function (msg) {
    var nav = document.getElementById(msg.id);
    if (!nav) return;

    var v = msg.selected;
    var esc = window.CSS && CSS.escape ? CSS.escape(v) : v;
    var button = nav.querySelector(".nav-link[data-value='" + esc + "']");
    if (button) {
      bootstrict.bs("Tab", button).show();
    }
  });
})(window);
