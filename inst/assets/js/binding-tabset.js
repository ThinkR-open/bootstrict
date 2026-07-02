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
    },
    unsubscribe: function (el) {
      if (window.bootstrap && window.bootstrap.Tab) {
        el.querySelectorAll(".nav-link").forEach(function (btn) {
          var inst = window.bootstrap.Tab.getInstance(btn);
          if (inst) inst.dispose();
        });
      }
    }
  });

  // Server -> client: show a tab by value.
  bootstrict.addHandler("tabset.update", function (msg) {
    var nav = document.getElementById(msg.id);
    if (!nav) return bootstrict.missing("tabset.update", msg.id);

    var v = msg.selected;
    var esc = window.CSS && CSS.escape ? CSS.escape(v) : v;
    var button = nav.querySelector(".nav-link[data-value='" + esc + "']");
    if (!button) {
      console.warn(
        "bootstrict: tabset.update — no tab with value '" + v +
          "' in #" + msg.id + "."
      );
      return;
    }
    var inst = bootstrict.bs("Tab", button);
    if (inst) inst.show();
  });
})(window);
