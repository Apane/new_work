# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  if $('#event_date').length > 0
    $('#event_date').datepicker
      format: 'yyyy-mm-dd'

  $('#event_time').timepicker
    scrollDefaultNow: true
