

function initAutocomplete() {
    $("#search_from, #search_to").autocomplete({
        source: function (request, response) {
            $.getJSON("/geocodes/autocomplete?term=" + request.term, function (data) {
                response($.map(data, function (el) {
                    return {
                        label: el.display_name,
                        value: el.display_name,
                        id: [el.lat, el.lon]
                    }
                }))
            })
        },
        minLength: 2,
        select: function (event, ui) {
            $('#' + this.id + '_coordinates').val(ui.item.id)
        }
    })
}