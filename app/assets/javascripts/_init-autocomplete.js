jQuery.fn.extend({
  geonameAutocomplete: function () {
    return this.autocomplete({
      minLength: 2,
      source: function (request, response) {
        $.getJSON("/cities/autocomplete?term=" + request.term, function (data) {
          response($.map(data, function (el) {
            return {
              value: el.city,
              city: el.city,
              postcode: el.postcode,
              country: el.country,
              lat: el.lat,
              lon: el.lon
            }
          }))
        });
    },
      select: function (event, ui) {
        // by default the change event is not triggered on hidden input fields
        // we need it to update the map instantly
        $('#' + this.id.replace(/city/, 'lat')).val(ui.item.lat).trigger('change');
        $('#' + this.id.replace(/city/, 'lon')).val(ui.item.lon).trigger('change');
      },
      create: function () {
        $(this).data('ui-autocomplete')._renderItem = function (ul, item) {
          return $("<li>")
            .append("<div><b>" + item.city + "</b><br />" + item.city + ', ' + item.country + ', ' + item.postcode + "</div>")
            .appendTo(ul);
        }
      }
    });
  }
});
