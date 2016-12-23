// Googla Analytics PageView Tracking compatibility
// see https://github.com/turbolinks/turbolinks/issues/73

document.addEventListener("turbolinks:load", function(event) {
  if (typeof ga === "function") {
    ga("set", "location", event.data.url);
    return ga("send", "pageview");
  }
});
