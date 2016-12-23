// Google Analytics Turbolinks integration
// http://reed.github.io/turbolinks-compatibility/google_analytics.html

this.GoogleAnalytics = (function() {
  function GoogleAnalytics() {}

  GoogleAnalytics.load = function() {
    (function(i, s, o, g, r, a, m) {
      i['GoogleAnalyticsObject'] = r;
      i[r] = i[r] || function() {
          (i[r].q = i[r].q || []).push(arguments);
        };
      i[r].l = 1 * new Date();
      a = s.createElement(o);
      m = s.getElementsByTagName(o)[0];
      a.async = 1;
      a.src = g;
      m.parentNode.insertBefore(a, m);
    })(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');
    ga('create', GoogleAnalytics.analyticsId(), 'auto');
    if (typeof Turbolinks !== 'undefined' && Turbolinks.supported) {
      return document.addEventListener("page:change", (function() {
        return GoogleAnalytics.trackPageview();
      }), true);
    } else {
      return GoogleAnalytics.trackPageview();
    }
  };

  GoogleAnalytics.trackPageview = function(url) {
    if (!GoogleAnalytics.isLocalRequest()) {
      return ga('send', {
        hitType: 'pageview',
        page: location.pathname
      });
    }
  };

  GoogleAnalytics.isLocalRequest = function() {
    return GoogleAnalytics.documentDomainIncludes("local");
  };

  GoogleAnalytics.documentDomainIncludes = function(str) {
    return document.domain.indexOf(str) !== -1;
  };

  GoogleAnalytics.analyticsId = function() {
    return 'UA-76224004-2';
  };

  return GoogleAnalytics;

})();

GoogleAnalytics.load();
