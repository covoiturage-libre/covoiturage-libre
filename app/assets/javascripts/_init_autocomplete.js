jQuery.fn.extend({
    geonameAutocomplete: function () {
        return this.autocomplete({
            minLength: 2,
            source: function (request, response) {
                $.getJSON("/geonames/autocomplete?term=" + request.term, function (data) {
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
                })
            },
            select: function (event, ui) {
                $('#' + this.id.replace(/city/, 'lat')).val(ui.item.lat)
                $('#' + this.id.replace(/city/, 'lon')).val(ui.item.lon)
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
