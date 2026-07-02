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
    },
    unsubscribe: function (el) {
      if (window.bootstrap && window.bootstrap.Collapse) {
        var inst = window.bootstrap.Collapse.getInstance(el);
        if (inst) inst.dispose();
      }
    }
  });

  // Server -> client: show / hide / toggle.
  bootstrict.addHandler("collapse.update", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return bootstrict.missing("collapse.update", msg.id);
    var action = msg.action;
    if (action !== "show" && action !== "hide" && action !== "toggle") return;
    var inst = bootstrict.bs("Collapse", el);
    if (inst) inst[action]();
  });
})(window);
