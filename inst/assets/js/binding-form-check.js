/* bootstrict form-check repair ---------------------------------------------
 *
 * shiny's updateRadioButtons() / updateCheckboxGroupInput() replace the whole
 * options block with HTML generated server-side by shiny:::generateOptions(),
 * which has no theme branch and always emits Bootstrap 3 markup
 * (<div class="radio"><label><input>). bootstrict's enhancement happens once,
 * at render time, so without this the control silently loses .form-check,
 * .form-check-input and .form-check-label on the first update -- breaking the
 * package's promise that shiny's own updaters keep working unchanged.
 *
 * Not an input binding: shiny owns the input, we only put the classes back.
 * ------------------------------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  var GROUP = "[data-bootstrict='form-check']";
  var LEGACY = ".radio, .radio-inline, .checkbox, .checkbox-inline";

  function enhance(group) {
    var inline = group.hasAttribute("data-bootstrict-inline");
    var reverse = group.hasAttribute("data-bootstrict-reverse");

    group.querySelectorAll(LEGACY).forEach(function (wrapper) {
      var isInline =
        inline ||
        wrapper.classList.contains("radio-inline") ||
        wrapper.classList.contains("checkbox-inline");
      wrapper.classList.remove(
        "radio",
        "radio-inline",
        "checkbox",
        "checkbox-inline"
      );
      wrapper.classList.add("form-check");
      if (isInline) wrapper.classList.add("form-check-inline");
      if (reverse) wrapper.classList.add("form-check-reverse");
    });

    group.querySelectorAll(".form-check").forEach(function (wrapper) {
      wrapper
        .querySelectorAll("input[type='radio'], input[type='checkbox']")
        .forEach(function (input) {
          input.classList.add("form-check-input");
        });
      wrapper.querySelectorAll("label").forEach(function (label) {
        label.classList.add("form-check-label");
      });
    });
  }

  // Repair the group a replaced node belongs to, and any group inside it.
  function repair(node) {
    if (!node || node.nodeType !== 1) return;
    var owner = node.closest(GROUP);
    if (owner) enhance(owner);
    if (node.matches(GROUP)) enhance(node);
    node.querySelectorAll(GROUP).forEach(enhance);
  }

  function watch() {
    document.querySelectorAll(GROUP).forEach(enhance);
    if (!window.MutationObserver) return;
    new window.MutationObserver(function (records) {
      records.forEach(function (record) {
        Array.prototype.forEach.call(record.addedNodes, repair);
      });
    }).observe(document.body, { childList: true, subtree: true });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", watch);
  } else {
    watch();
  }
})(window);
