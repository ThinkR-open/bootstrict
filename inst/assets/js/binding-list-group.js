/* bootstrict list-group binding -------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Report the data-value of the currently active item (or null when none).
  bootstrict.eventBinding({
    name: "bootstrict.listgroup",
    selector: ".list-group[data-bootstrict='list-group']",
    // Resubmitted both on user clicks (below) and on server-driven updates,
    // which dispatch a synthetic "bootstrict:listgroup" event on the root.
    events: ["bootstrict:listgroup"],
    getValue: function (el) {
      var active = el.querySelector(".list-group-item.active");
      return active ? active.getAttribute("data-value") : null;
    },
    subscribe: function (el, callback, ns) {
      // Registered under the binding's jQuery namespace so the generic
      // unsubscribe ($(el).off(ns)) removes it on unbind — a bare
      // addEventListener would survive unbind/rebind cycles and stack up.
      $(el).on("click" + ns, function (e) {
        var item = e.target.closest(".list-group-item-action");
        if (!item || !el.contains(item)) return;
        // Anchor items would navigate; keep selection on the same page.
        // (preventDefault also covers disabled anchors reached by keyboard.)
        if (item.tagName === "A") e.preventDefault();
        if (item.classList.contains("disabled") || item.disabled) return;

        el.querySelectorAll(".list-group-item.active").forEach(function (other) {
          other.classList.remove("active");
          other.removeAttribute("aria-current");
        });
        item.classList.add("active");
        item.setAttribute("aria-current", "true");
        callback();
      });
    }
  });

  // Server -> client: activate the item carrying the given data-value.
  // `selected` absent -> leave the selection unchanged (documented no-op).
  bootstrict.addHandler("listgroup.update", function (msg) {
    var group = document.getElementById(msg.id);
    if (!group) return bootstrict.missing("listgroup.update", msg.id);

    if (msg.selected === null || typeof msg.selected === "undefined") return;

    var v = msg.selected;
    var item = group.querySelector(
      ".list-group-item[data-value='" +
        (window.CSS && CSS.escape ? CSS.escape(v) : v) +
        "']"
    );
    if (!item) {
      console.warn(
        "bootstrict: listgroup.update — no item with value '" + v +
          "' in #" + msg.id + "; selection left unchanged."
      );
      return;
    }

    group.querySelectorAll(".list-group-item.active").forEach(function (other) {
      other.classList.remove("active");
      other.removeAttribute("aria-current");
    });
    item.classList.add("active");
    item.setAttribute("aria-current", "true");

    // Notify the input binding so input$id reflects the new selection.
    $(group).trigger("bootstrict:listgroup");
  });
})(window);
