/* bootstrict alert binding -------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Report whether the alert is still on the page.
  //
  // The value is read from a flag rather than from the DOM: Bootstrap's
  // `closed.bs.alert` fires *after* the element has been removed, so by then
  // there is nothing left to inspect. `close.bs.alert` fires first, while the
  // element is still bound, which is the last chance to report FALSE.
  bootstrict.eventBinding({
    name: "bootstrict.alert",
    selector: ".alert[data-bootstrict='alert']",
    events: ["close.bs.alert"],
    getValue: function (el) {
      return !el.hasAttribute("data-bootstrict-closing");
    },
    subscribe: function (el, callback, ns) {
      $(el).on("close.bs.alert" + ns, function () {
        el.setAttribute("data-bootstrict-closing", "");
      });
    },
    unsubscribe: function (el) {
      if (window.bootstrap && window.bootstrap.Alert) {
        var inst = window.bootstrap.Alert.getInstance(el);
        if (inst) inst.dispose();
      }
    }
  });

  // Server -> client: close it, as the close button would.
  bootstrict.addHandler("alert.close", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return bootstrict.missing("alert.close", msg.id);
    var inst = bootstrict.bs("Alert", el);
    if (inst) inst.close();
  });
})(window);
