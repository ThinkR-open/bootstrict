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
    subscribe: function (el, callback) {
      el.addEventListener("click", function (e) {
        var item = e.target.closest(".list-group-item-action");
        if (!item || !el.contains(item)) return;
        if (item.classList.contains("disabled") || item.disabled) return;
        // Anchor items would navigate; keep selection on the same page.
        if (item.tagName === "A") e.preventDefault();

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
  bootstrict.addHandler("listgroup.update", function (msg) {
    var group = document.getElementById(msg.id);
    if (!group) return;

    group.querySelectorAll(".list-group-item.active").forEach(function (other) {
      other.classList.remove("active");
      other.removeAttribute("aria-current");
    });

    if (msg.selected !== null && typeof msg.selected !== "undefined") {
      var v = msg.selected;
      var item = group.querySelector(
        ".list-group-item[data-value='" +
          (window.CSS && CSS.escape ? CSS.escape(v) : v) +
          "']"
      );
      if (item) {
        item.classList.add("active");
        item.setAttribute("aria-current", "true");
      }
    }

    // Notify the input binding so input$id reflects the new selection.
    $(group).trigger("bootstrict:listgroup");
  });
})(window);
