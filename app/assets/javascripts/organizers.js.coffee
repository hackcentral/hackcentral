# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#jQuery ->
#  $('#organizer_user_id').chosen()
#  no_results_text: 'No users found'
#  width: '200px'

$ ->
  $('#organizer_user_id').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
    width: '200px'
