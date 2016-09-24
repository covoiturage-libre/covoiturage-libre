$(document).on('page:fetch', function() {
    $(".loading-indicator").show()
})

$(document).on('page:change', function() {
    $(".loading-indicator").hide()
})

function initDatepicker() {
    $('.datepicker').datepicker({
        language: 'fr'
    })
}