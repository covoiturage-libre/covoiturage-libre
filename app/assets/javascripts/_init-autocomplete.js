jQuery.fn.extend({
  geonameAutocomplete: function () {
    return this.autocomplete({
      minLength: 2,
      // automatically focus first item from autocomplete menu
      autoFocus: true,
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
        if (typeof ga === "function") {
          ga('send', 'event', 'Ville', 'select', ui.item.city );
        }
      },
      create: function () {
        $(this).data('ui-autocomplete')._renderItem = function (ul, item) {
          return $("<li>")
            .append("<div><b>" + item.city + "</b><br />" + item.city + ', ' + item.country + ', ' + item.postcode + "</div>")
            .appendTo(ul);
        }
      },
      focus: function (event, ui) {
        // memorize latest focused item for selection upon focusout
        this.latest_focus = ui.item;
      }
    }).blur(function () {
      if ($(this).val() == "") {
        $(this).parent().next(2).find("input").val('');
      }
      // populate with last focused element if different from current
      // ie force autocomplete
      if (typeof this.latest_focus !== 'undefined'
      && this.latest_focus.value != this.value) {
        this.value = this.latest_focus.value;
        var lat = $('#' + this.id.replace(/city/, 'lat'));
        var lon = $('#' + this.id.replace(/city/, 'lon'));
        lat.val(this.latest_focus.lat).trigger('change');
        lon.val(this.latest_focus.lon).trigger('change');
      }
    });
  }
});
