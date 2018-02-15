jQuery.fn.extend({
  geonameAutocomplete: function () {
    function selectCityItem(cityItem, input) {
      // by default the change event is not triggered on hidden input fields
      // we need it to update the map instantly
      var lat = $("#" + input.id.replace(/city/, "lat"));
      var lon = $("#" + input.id.replace(/city/, "lon"));

      lat.val(cityItem.lat).trigger("change");
      lon.val(cityItem.lon).trigger("change");

      // Hide previous error message
      var inputSelector = $(input);
      inputSelector.parent().removeClass("has-error");
      inputSelector.prev(".help-block").hide();

      if (typeof ga === "function") {
        ga("send", "event", "Ville", "select", cityItem.city);
      }
    }

    return this.autocomplete({
      minLength: 0,
      // automatically focus first item from autocomplete menu
      autoFocus: true,
      source: function(request, response) {
        var listUri;
        if (request.term.length < 2) {
          listUri = "/cities/main";
        } else {
          listUri = "/cities/autocomplete?term=" + request.term;
        }

        $.getJSON(listUri, function (data) {
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
      select: function(event, ui) {
        selectCityItem(ui.item, this);
      },
      create: function() {
        $(this).data("ui-autocomplete")._renderItem = function (ul, item) {
          return $("<li>")
            .append("<div><b>" + item.city + "</b><br />" + item.city + ", " + item.country + ", " + item.postcode + "</div>")
            .appendTo(ul);
        }
      },
      focus: function(event, ui) {
        // memorize latest focused item for selection upon focusout
        this.latestFocus = ui.item;
      }
    }).blur(function () {
      if ($(this).val() === "") { // Reset
        var lat = $("#" + this.id.replace(/city/, "lat"));
        var lon = $("#" + this.id.replace(/city/, "lon"));

        lat.val("");
        lon.val("");
      }
      else {
        // populate with last focused element if different from current
        // ie force autocomplete
        if (typeof this.latestFocus !== "undefined"
        && this.latestFocus.value !== this.value) {
          this.value = this.latestFocus.value;
          selectCityItem(this.latestFocus, this);
        }
      }
    }).focus(function () {
      // reopen completion menu on focus
      $(this).data("ui-autocomplete").search($(this).val());
    });
  }
});
