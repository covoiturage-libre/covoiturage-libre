// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/autocomplete
//= require jquery-ui/sortable
//= require jquery-ui/datepicker
//= require jquery-ui/datepicker-fr
//= require bootstrap-sprockets
//= require leaflet.js.erb
//= require leaflet-routing-machine
//= require cocoon
//= require Chart.bundle
//= require chartkick
//= require _init-autocomplete.js
//= require _trip-drawer.js
//= require turbolinks
//= require ga

$(document).ready(function() {
  var activeStickerIndex = 0;
  var stickersLength = $('.c-stickers-carousel__item').length;

  function showActiveCarousel() {
    $('.c-stickers-carousel__item').hide();
    var index = (activeStickerIndex % stickersLength) + 1;
    $('.c-stickers-carousel__item:nth-child(' + index + ')').show();
    $('#active-sticker').html(index);
  }

  $('.js-carousel-left').on('click', function() {
    activeStickerIndex = activeStickerIndex > 0 ? activeStickerIndex - 1 : stickersLength - 1;
    showActiveCarousel();
  });

  $('.js-carousel-right').on('click', function() {
    activeStickerIndex += 1;
    showActiveCarousel();
  });

  showActiveCarousel();
});
