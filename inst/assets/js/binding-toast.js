/* bootstrict toast binding ------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  // Report whether the toast is currently shown.
  bootstrict.eventBinding({
    name: "bootstrict.toast",
    selector: ".toast[data-bootstrict='toast']",
    events: ["shown.bs.toast", "hidden.bs.toast"],
    getValue: function (el) {
      return el.classList.contains("show");
    }
  });

  // Map a placement keyword to Bootstrap position utility classes (mirrors the
  // R-side toast_placement_class()).
  var PLACEMENTS = {
    "top-start": "top-0 start-0",
    "top-center": "top-0 start-50 translate-middle-x",
    "top-end": "top-0 end-0",
    "middle-start": "top-50 start-0 translate-middle-y",
    "middle-center": "top-50 start-50 translate-middle",
    "middle-end": "top-50 end-0 translate-middle-y",
    "bottom-start": "bottom-0 start-0",
    "bottom-center": "bottom-0 start-50 translate-middle-x",
    "bottom-end": "bottom-0 end-0"
  };

  function placementClasses(placement) {
    return PLACEMENTS[placement] || PLACEMENTS["top-end"];
  }

  // Find an existing container at this placement, or create one.
  function getContainer(placement) {
    var pos = placementClasses(placement);
    var containers = document.querySelectorAll(".toast-container.position-fixed");
    for (var i = 0; i < containers.length; i++) {
      var ok = pos.split(" ").every(function (cls) {
        return containers[i].classList.contains(cls);
      });
      if (ok) return containers[i];
    }
    var container = document.createElement("div");
    container.className = "toast-container position-fixed p-3 " + pos;
    document.body.appendChild(container);
    return container;
  }

  // Server -> client: show / hide an existing toast.
  bootstrict.addHandler("toast.show", function (msg) {
    var el = document.getElementById(msg.id);
    if (el) bootstrict.bs("Toast", el).show();
  });

  bootstrict.addHandler("toast.hide", function (msg) {
    var el = document.getElementById(msg.id);
    if (el) bootstrict.bs("Toast", el).hide();
  });

  // Server -> client: build a transient toast and show it.
  bootstrict.addHandler("toast.notify", function (msg) {
    if (!window.bootstrap || !window.bootstrap.Toast) {
      console.warn("bootstrict: bootstrap.Toast is unavailable.");
      return;
    }

    var container = getContainer(msg.placement);

    var toast = document.createElement("div");
    toast.className = "toast";
    if (msg.color) toast.classList.add("text-bg-" + msg.color);
    toast.setAttribute("role", "alert");
    toast.setAttribute("aria-live", "assertive");
    toast.setAttribute("aria-atomic", "true");

    if (msg.title) {
      var header = document.createElement("div");
      header.className = "toast-header";

      var strong = document.createElement("strong");
      strong.className = "me-auto";
      strong.textContent = msg.title;
      header.appendChild(strong);

      var btn = document.createElement("button");
      btn.type = "button";
      btn.className = "btn-close";
      btn.setAttribute("data-bs-dismiss", "toast");
      btn.setAttribute("aria-label", "Close");
      header.appendChild(btn);

      toast.appendChild(header);
    }

    var bodyEl = document.createElement("div");
    bodyEl.className = "toast-body";
    bodyEl.textContent = msg.body;
    toast.appendChild(bodyEl);

    container.appendChild(toast);

    var options = {};
    if (msg.delay != null) options.delay = msg.delay;
    var instance = new window.bootstrap.Toast(toast, options);

    toast.addEventListener("hidden.bs.toast", function () {
      toast.remove();
    });

    instance.show();
  });
})(window);
