/* bootstrict dropdown binding ----------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Report whether the menu is open. Bootstrap's events bubble, so a dropdown
  // nested inside another marked element would report for both: only react to
  // events whose target is this dropdown's own toggle.
  bootstrict.eventBinding({
    name: "bootstrict.dropdown",
    selector: "[data-bootstrict='dropdown']",
    events: ["shown.bs.dropdown", "hidden.bs.dropdown"],
    eventFilter: function (el, event) {
      var toggle = el.querySelector(":scope > .dropdown-toggle");
      return !toggle || event.target === toggle || event.target === el;
    },
    getValue: function (el) {
      var toggle = el.querySelector(".dropdown-toggle");
      return toggle
        ? toggle.getAttribute("aria-expanded") === "true"
        : el.querySelector(".dropdown-menu.show") !== null;
    },
    unsubscribe: function (el) {
      if (window.bootstrap && window.bootstrap.Dropdown) {
        var toggle = el.querySelector(".dropdown-toggle");
        var inst = toggle && window.bootstrap.Dropdown.getInstance(toggle);
        if (inst) inst.dispose();
      }
    }
  });

  // Server -> client. Bootstrap's Dropdown instance lives on the toggle, not
  // on the wrapper that carries the id.
  function call(method) {
    return function (msg) {
      var el = document.getElementById(msg.id);
      var toggle = el && el.querySelector(".dropdown-toggle");
      if (!toggle) return bootstrict.missing("dropdown." + method, msg.id);
      var inst = bootstrict.bs("Dropdown", toggle);
      if (inst) inst[method]();
    };
  }

  bootstrict.addHandler("dropdown.show", call("show"));
  bootstrict.addHandler("dropdown.hide", call("hide"));
  bootstrict.addHandler("dropdown.toggle", call("toggle"));
})(window);
