// Googla Analytics PageView Tracking compatibility
// see https://github.com/turbolinks/turbolinks/issues/73
// also see : http://reed.github.io/turbolinks-compatibility/google_universal_analytics.html
// Google Analytics ref here : https://developers.google.com/analytics/devguides/collection/analyticsjs/pages

document.addEventListener("turbolinks:load", function(event) {
  if (typeof ga === "function") {
    return ga('send', 'pageview', location.pathname);
  }
});
