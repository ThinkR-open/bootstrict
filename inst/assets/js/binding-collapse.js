/* bootstrict collapse binding ---------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Report whether the collapse is currently shown.
  bootstrict.eventBinding({
    name: "bootstrict.collapse",
    selector: ".collapse[data-bootstrict='collapse']",
    events: ["shown.bs.collapse", "hidden.bs.collapse"],
    getValue: function (el) {
      return el.classList.contains("show");
    }
  });

  // Server -> client: show / hide / toggle.
  bootstrict.addHandler("collapse.update", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return;
    var action = msg.action;
    if (action !== "show" && action !== "hide" && action !== "toggle") return;
    bootstrict.bs("Collapse", el)[action]();
  });
})(window);
