
function initDatepicker() {
    $('.datepicker').datepicker({
        autoclose: true,
        language: 'fr'
    })
}

function initAutocomplete() {
    $('.geocoder').autocomplete({
        source: function (request, response) {
            $.getJSON("/geocodes/autocomplete?term=" + request.term, function (data) {
                response($.map(data, function (el) {
                    return {
                        label: el.city,
                        value: el.city,
                        id: [el.lat, el.lon]
                    }
                }))
            })
        },
        minLength: 2,
        select: function (event, ui) {
            $('#' + this.id.replace(/city/, 'lat')).val(ui.item.id[0])
            $('#' + this.id.replace(/city/, 'lon')).val(ui.item.id[1])
        }
    })
}
