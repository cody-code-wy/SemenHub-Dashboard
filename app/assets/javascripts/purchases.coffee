# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'purchases:show', ->
  if $('#purchase').data('purchase-state') == 'created'
    $('input:radio').change ->
      if $('#shipment_options_option_storage').is ':checked'
        $('.storage-facility-selector').show()
      else
        $('.storage-facility-selector').hide()
