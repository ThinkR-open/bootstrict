/* bootstrict progress binding ---------------------------------------------
 *
 * Progress is display-only (not a Shiny input), so there is no eventBinding:
 * just a server -> client handler driven by update_bs_progress().
 * ------------------------------------------------------------------------- */
(function (window) {
  "use strict";
  var bootstrict = window.bootstrict;
  if (!bootstrict) return;

  function num(x, fallback) {
    var n = parseFloat(x);
    return isNaN(n) ? fallback : n;
  }

  // Server -> client: update a progress bar's value / label / colour / bounds.
  bootstrict.addHandler("progress.update", function (msg) {
    var bar = document.getElementById(msg.id);
    if (!bar) return;

    // Resolve the effective scale, preferring fresh values from the message.
    var min = msg.min != null ? num(msg.min, 0) :
      num(bar.getAttribute("aria-valuemin"), 0);
    var max = msg.max != null ? num(msg.max, 100) :
      num(bar.getAttribute("aria-valuemax"), 100);

    if (msg.min != null) bar.setAttribute("aria-valuemin", min);
    if (msg.max != null) bar.setAttribute("aria-valuemax", max);

    if (msg.value != null) {
      var value = num(msg.value, 0);
      var span = max - min;
      var pct = span === 0 ? 0 : Math.round((100 * (value - min)) / span);
      bar.style.width = pct + "%";
      bar.setAttribute("aria-valuenow", value);
    }

    if (msg.label != null) {
      bar.textContent = msg.label;
    }

    if (msg.color != null) {
      // Swap any existing bg-* theme class for the new one.
      bar.className = bar.className
        .split(/\s+/)
        .filter(function (c) {
          return c && c.indexOf("bg-") !== 0;
        })
        .concat("bg-" + msg.color)
        .join(" ");
    }
  });
})(window);
