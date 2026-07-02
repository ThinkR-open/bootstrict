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
    },
    unsubscribe: function (el) {
      if (window.bootstrap && window.bootstrap.Toast) {
        var inst = window.bootstrap.Toast.getInstance(el);
        if (inst) inst.dispose();
      }
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

  // Theme colours whose .text-bg-* background is dark enough to need the
  // dark-context close-button variant (data-bs-theme="dark", the Bootstrap
  // 5.3 idiom — .btn-close-white is deprecated).
  var DARK_BG = ["primary", "secondary", "success", "danger", "dark"];

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
    // A live region, so screen readers announce dynamically inserted toasts.
    container.setAttribute("aria-live", "polite");
    container.setAttribute("aria-atomic", "true");
    document.body.appendChild(container);
    return container;
  }

  function closeButton(color) {
    var btn = document.createElement("button");
    btn.type = "button";
    btn.className = "btn-close";
    if (DARK_BG.indexOf(color) !== -1) {
      btn.setAttribute("data-bs-theme", "dark");
    }
    btn.setAttribute("data-bs-dismiss", "toast");
    btn.setAttribute("aria-label", "Close");
    return btn;
  }

  // Server -> client: show / hide an existing toast.
  bootstrict.addHandler("toast.show", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return bootstrict.missing("toast.show", msg.id);
    var inst = bootstrict.bs("Toast", el);
    if (inst) inst.show();
  });

  bootstrict.addHandler("toast.hide", function (msg) {
    var el = document.getElementById(msg.id);
    if (!el) return bootstrict.missing("toast.hide", msg.id);
    var inst = bootstrict.bs("Toast", el);
    if (inst) inst.hide();
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

    var bodyEl = document.createElement("div");
    bodyEl.className = "toast-body";
    bodyEl.textContent = msg.body;

    if (msg.title) {
      var header = document.createElement("div");
      header.className = "toast-header";

      var strong = document.createElement("strong");
      strong.className = "me-auto";
      strong.textContent = msg.title;
      header.appendChild(strong);
      header.appendChild(closeButton(msg.color));

      toast.appendChild(header);
      toast.appendChild(bodyEl);
    } else {
      // Header-less pattern from the Bootstrap docs: body + close button in a
      // flex row, so the toast stays dismissible (essential when
      // autohide = FALSE).
      var flex = document.createElement("div");
      flex.className = "d-flex";
      var btn = closeButton(msg.color);
      btn.classList.add("me-2", "m-auto");
      flex.appendChild(bodyEl);
      flex.appendChild(btn);
      toast.appendChild(flex);
    }

    container.appendChild(toast);

    var options = {};
    if (msg.delay != null) options.delay = msg.delay;
    if (msg.autohide != null) options.autohide = msg.autohide !== false;
    var instance = new window.bootstrap.Toast(toast, options);

    toast.addEventListener("hidden.bs.toast", function () {
      // Dispose *before* removing: Bootstrap holds a strong reference to the
      // element in its instance map, so remove() alone would leak the
      // detached node (and its listeners) for the page lifetime.
      instance.dispose();
      toast.remove();
    });

    instance.show();
  });
})(window);
