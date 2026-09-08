/* bootstrict validation state ----------------------------------------------
 *
 * set_bs_validation() toggles .is-valid / .is-invalid on the control behind an
 * input id and, optionally, rewrites the text of the feedback message declared
 * with bs_feedback(). No input binding: validation is driven entirely from the
 * server.
 * ------------------------------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  var CONTROL =
    ".form-control, .form-select, .form-check-input, .form-range, textarea";

  bootstrict.addHandler("validation.set", function (msg) {
    var root = document.getElementById(msg.id);
    if (!root) {
      bootstrict.missing("validation.set", msg.id);
      return;
    }

    // The id sits on the control itself for simple inputs, and on shiny's
    // container for choice groups (radio, checkbox group).
    var onControl = root.matches(CONTROL);
    var controls = onControl ? [root] : root.querySelectorAll(CONTROL);

    Array.prototype.forEach.call(controls, function (el) {
      el.classList.remove("is-valid", "is-invalid");
      if (msg.state === "valid" || msg.state === "invalid") {
        el.classList.add("is-" + msg.state);
      }
    });

    if (msg.message == null || msg.state === "none") return;
    // bs_feedback() puts the message inside the control's own parent, so it is
    // the following sibling Bootstrap's `.is-* ~ .*-feedback` rule needs.
    var scope = onControl ? root.parentNode : root;
    var feedback = scope && scope.querySelector("." + msg.state + "-feedback");
    if (feedback) feedback.textContent = msg.message;
  });
})(window);
