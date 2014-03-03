jQuery ->
  $('.best_in_place').best_in_place();
  $.extend $.fn.datepicker.defaults,
    format: "yyyy-mm-dd"

  $(".best_in_place").bind "ajax:success", ->
    $.ajax '/update_profile_completness',
      type: 'GET'
