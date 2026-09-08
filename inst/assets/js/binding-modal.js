/* bootstrict modal binding ------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Report whether the modal is currently shown.
  bootstrict.eventBinding({
    name: "bootstrict.modal",
    selector: ".modal[data-bootstrict='modal']",
    events: ["shown.bs.modal", "hidden.bs.modal"],
    getValue: function (el) {
      return el.classList.contains("show");
    },
    unsubscribe: bootstrict.disposeOnHidden("Modal", "hidden.bs.modal")
  });

  // Server -> client: show / hide / toggle.
  bootstrict.addHandler("modal.show", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return bootstrict.missing("modal.show", msg.id);
    var inst = bootstrict.bs("Modal", el);
    if (inst) inst.show();
  });

  bootstrict.addHandler("modal.hide", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return bootstrict.missing("modal.hide", msg.id);
    var inst = bootstrict.bs("Modal", el);
    if (inst) inst.hide();
  });

  bootstrict.addHandler("modal.toggle", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return bootstrict.missing("modal.toggle", msg.id);
    var inst = bootstrict.bs("Modal", el);
    if (inst) inst.toggle();
  });
})(window);
