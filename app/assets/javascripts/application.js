// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// require jquery-fileupload/basic
// require jquery-fileupload/vendor/tmpl
// require rails-timeago

//
// require bootstrap-editable
// bootstrap-editable-rails
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.iframe-transport
//= require jquery.remotipart
//= require jquery.ui.all
//= require bootstrap
//= require addresspicker.js
//= require bootstrap-datepicker
//= require bootstrap-timepicker
//= require events
//= require new_design/jquery-selectify
//= require new_design/jquery.multi-accordion-1.5.3
//= require new_design/ddaccordion.js
//= require pnotify
//= require best_in_place
//= require bootstrap-wysihtml5
//= require jquery.autoSave
//= require rails-timeago
//= require landing

$.pnotify.defaults.history = false

function cycleImages(){
  var $active = $('#background_cycler .active');
  var $next = ($('#background_cycler .active').next().length > 0) ? $('#background_cycler .active').next() : $('#background_cycler img:first');
      $next.css('z-index',2);//move the next image up the pile
      $active.fadeOut(1500,function(){//fade out the top image
      $active.css('z-index',1).show().removeClass('active');//reset the z-index and unhide the image
      $next.css('z-index',3).addClass('active');//make the next image the top one
  });
}

$(window).load(function(){
  $('#background_cycler').show(0);//fade the background back in once all the images are loaded
    // run every 7s
  setInterval('cycleImages()', 2100);
})

