jQuery.fn.extend({
  geonameAutocomplete: function () {
    return this.autocomplete({
      minLength: 2,
      // automatically focus first item from autocomplete menu
      autoFocus: true,
      source(request, response) {
        $.getJSON("/cities/autocomplete?term=" + request.term, function (data) {
          response($.map(data, function (el) {
            return {
              value: el.city,
              city: el.city,
              postcode: el.postcode,
              country: el.country,
              lat: el.lat,
              lon: el.lon
            };
          }));
        });
      },
      select(event, ui) {
        // by default the change event is not triggered on hidden input fields
        // we need it to update the map instantly
        var lat = $("#" + this.id.replace(/city/, "lat"));
        var lon = $("#" + this.id.replace(/city/, "lon"));
        lat.val(ui.item.lat).trigger("change");
        lon.val(ui.item.lon).trigger("change");

        if (typeof ga === "function") {
          ga("send", "event", "Ville", "select", ui.item.city);
        }
      },
      create() {
        $(this).data("ui-autocomplete")._renderItem = function (ul, item) {
          return $("<li>")
            .append("<div><b>" + item.city + "</b><br />" + item.city + ", " + item.country + ", " + item.postcode + "</div>")
            .appendTo(ul);
        }
      },
      focus(event, ui) {
        // memorize latest focused item for selection upon focusout
        this.latestFocus = ui.item;
      }
    }).blur(function () {
      if ($(this).val() === "") {
        $(this).parent().next(2).find("input").val("");
      }

      // populate with last focused element if different from current
      // ie force autocomplete
      if (typeof this.latestFocus !== "undefined"
      && this.latestFocus.value !== this.value) {
        this.value = this.latestFocus.value;
        var lat = $("#" + this.id.replace(/city/, "lat"));
        var lon = $("#" + this.id.replace(/city/, "lon"));
        lat.val(this.latestFocus.lat).trigger("change");
        lon.val(this.latestFocus.lon).trigger("change");

        if (typeof ga === "function") {
          ga('send', 'event', 'Ville', 'select', this.latestFocus.city);
        }
      }
    }).focus(function () {
      // reopen completion menu on focus
      $(this).data("ui-autocomplete").search($(this).val());
    });
  }
});
