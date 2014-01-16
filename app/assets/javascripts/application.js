// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// require bootstrap-editable
// bootstrap-editable-rails
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require bootstrap-datepicker
//= require jquery_ujs
//= require jquery_nested_form
//= require bootstrap
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require best_in_place
//= require pnotify
//= require rails-timeago
//= require_tree .

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
  setInterval('cycleImages()', 3000);
})

$(function(){

    $('.breadcrumb li a').on('click', function(e){


        var $thisA = $(this);
        var $li = $thisA.parents('ul');

        if (!$thisA.hasClass('active'))
        {
            $li.find('a.active').removeClass('active');
                $thisA.addClass('active');
        }

    })

})
