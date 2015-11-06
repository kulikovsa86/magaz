// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-select
//= require defaults-ru_RU
//= require tinycolor-0.9.15.min
//= require pick-a-color-1.2.3.min
//= require bootstrap-wysihtml5
//= require bootstrap-wysihtml5/locales/ru-RU
//= require lightbox

//= require_tree .

var ready;
ready = function() {
  $('.selectpicker').selectpicker({
  });

  $(".pick-a-color").pickAColor();

  $('.wysihtml5').each(function(i, elem) {
      $(elem).wysihtml5();
    });
}

$( document ).ready(ready);
$( document ).on('page:load', ready)