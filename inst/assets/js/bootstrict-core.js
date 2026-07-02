/* bootstrict-core.js -------------------------------------------------------
 *
 * Defines the window.bootstrict namespace that every per-component binding
 * file relies on. Loaded first by bootstrict_dep().
 *
 * Two extension points:
 *   1. bootstrict.eventBinding({...})  -> register a Shiny input binding that
 *      reports a stateful component's value, driven by Bootstrap JS events.
 *   2. bootstrict.addHandler(name, fn) -> register a server -> client message
 *      handler (used by update_*() / *_proxy() helpers). Dispatched through a
 *      single "bootstrict-message" custom message, payload { method, ... }.
 * ------------------------------------------------------------------------- */
(function (window) {
  "use strict";

  var bootstrict = window.bootstrict || {};
  window.bootstrict = bootstrict;

  // --- Bootstrap instance helper -----------------------------------------
  // bootstrict.bs("Collapse", el, opts) -> bootstrap.Collapse instance.
  bootstrict.bs = function (component, el, options) {
    if (!window.bootstrap || !window.bootstrap[component]) {
      console.warn("bootstrict: bootstrap." + component + " is unavailable.");
      return null;
    }
    // Collapse's constructor default is {toggle: true}, which *toggles the
    // panel inside the constructor* the first time an instance is created —
    // a server "hide" on a hidden panel would show it. Bootstrap's own data
    // API always instantiates with {toggle: false}; so do we.
    if (component === "Collapse" && !(options && "toggle" in options)) {
      options = Object.assign({ toggle: false }, options);
    }
    return window.bootstrap[component].getOrCreateInstance(el, options || {});
  };

  // Warn (once per call) when a server message targets a missing element —
  // typically a namespacing mistake inside a Shiny module.
  bootstrict.missing = function (method, id) {
    console.warn(
      "bootstrict: " + method + " targets #" + id + ", which is not in the DOM. " +
      "Check the id (inside a module, ids are namespaced automatically)."
    );
  };

  // --- Input binding factory ---------------------------------------------
  // opts: {
  //   name:        unique binding name (required)
  //   selector:    CSS selector used by find() (required)
  //   getValue:    function(el) -> value (required)
  //   events:      array of (bubbling) DOM/Bootstrap event names to resubmit
  //                on. Each entry is either a string (immediate submit) or
  //                {name, deferred: true} to route through getRatePolicy().
  //   eventFilter: optional function(el, event) -> boolean; when false the
  //                event is ignored (e.g. events bubbling from a nested copy
  //                of the same component).
  //   getType:     optional function(el) -> Shiny output type string
  //   initialize:  optional function(el)
  //   subscribe:   optional function(el, callback, ns) for custom wiring; use
  //                the provided jQuery namespace (`$(el).on("click" + ns, …)`)
  //                so the generic unsubscribe can remove the handlers.
  //   unsubscribe: optional function(el) for extra teardown (e.g. disposing
  //                the Bootstrap instance); jQuery handlers registered under
  //                the binding namespace are removed automatically.
  //   receiveMessage: optional function(el, data) for update_*()
  //   ratePolicy:  optional { policy, delay }
  // }
  bootstrict.eventBinding = function (opts) {
    if (!window.Shiny) return;

    var Binding = new Shiny.InputBinding();

    $.extend(Binding, {
      find: function (scope) {
        return $(scope).find(opts.selector);
      },
      getId: function (el) {
        return el.id || (el.dataset ? el.dataset.id : undefined);
      },
      getValue: function (el) {
        return opts.getValue(el);
      },
      getType: opts.getType || undefined,
      initialize: function (el) {
        if (opts.initialize) opts.initialize(el);
      },
      subscribe: function (el, callback) {
        var ns = "." + opts.name.replace(/[^A-Za-z0-9]/g, "");
        if (opts.subscribe) {
          opts.subscribe(el, callback, ns);
        }
        (opts.events || []).forEach(function (ev) {
          var name = typeof ev === "string" ? ev : ev.name;
          var deferred = typeof ev === "string" ? false : ev.deferred === true;
          $(el).on(name + ns, function (e) {
            if (opts.eventFilter && !opts.eventFilter(el, e)) return;
            callback(deferred);
          });
        });
      },
      unsubscribe: function (el) {
        var ns = "." + opts.name.replace(/[^A-Za-z0-9]/g, "");
        if (opts.unsubscribe) opts.unsubscribe(el);
        $(el).off(ns);
      },
      receiveMessage: function (el, data) {
        if (opts.receiveMessage) opts.receiveMessage(el, data);
      },
      getRatePolicy: function () {
        return opts.ratePolicy || null;
      }
    });

    Shiny.inputBindings.register(Binding, opts.name);
    return Binding;
  };

  // --- server -> client message handlers ---------------------------------
  bootstrict.handlers = bootstrict.handlers || {};

  bootstrict.addHandler = function (method, fn) {
    bootstrict.handlers[method] = fn;
  };

  // Resolve a target element from a message that carries either `id` or
  // `selector`.
  bootstrict.resolve = function (msg) {
    if (msg.selector) return document.querySelector(msg.selector);
    if (msg.id) return document.getElementById(msg.id);
    return null;
  };

  if (window.Shiny) {
    Shiny.addCustomMessageHandler("bootstrict-message", function (msg) {
      var fn = bootstrict.handlers[msg.method];
      if (typeof fn === "function") {
        fn(msg);
      } else {
        console.warn("bootstrict: no handler registered for", msg.method);
      }
    });
  }
})(window);
