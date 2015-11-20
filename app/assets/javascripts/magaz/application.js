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
//= require image-picker
//= require bootstrap-switch
//= require moment
//= require moment/ru
//= require bootstrap-datetimepicker
//= require bootbox

//= require_tree .

var ready;
ready = function() {
  $('.selectpicker').selectpicker({
  });

  $(".pick-a-color").pickAColor();

  $('.wysihtml5').each(function(i, elem) {
      $(elem).wysihtml5();
    });
  $(".image-picker").imagepicker({

  })
  $(".switcher").bootstrapSwitch();

  $(".datetimepicker").datetimepicker({
  });

  // $(".bootbox").click(function() {
  //   bootbox.confirm("A you sure?");
  // });

  window.myCustomConfirmBox = function(message, callback) {
    return bootbox.dialog({
      message: message,
      "class": 'class-confirm-box',
      className: "my-modal",
      buttons: {
        success: {
          label: "Уверен!",
          className: "btn-danger",
          callback: function() {
            return callback();
          }
        },
        chickenout: {
          label: "Нет, не уверен",
          className: "btn-success pull-left"
        }
      }
    });
  };
  return $.rails.allowAction = function(element) {
    var answer, callback, message;
    message = element.data("confirm");
    if (!message) {
      return true;
    }
    answer = false;
    callback = void 0;
    if ($.rails.fire(element, "confirm")) {
      myCustomConfirmBox(message, function() {
        var oldAllowAction;
        callback = $.rails.fire(element, "confirm:complete", [answer]);
        if (callback) {
          oldAllowAction = $.rails.allowAction;
          $.rails.allowAction = function() {
            return true;
          };
          element.trigger("click");
          return $.rails.allowAction = oldAllowAction;
        }
      });
    }
    return false;
  };
}

$( document ).ready(ready);
$( document ).on('page:load', ready)