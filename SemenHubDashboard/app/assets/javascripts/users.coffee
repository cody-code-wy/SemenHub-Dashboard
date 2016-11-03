# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  billing_addr = $('#billing_address > .address')
  payee_addr = $('#payee_address > .address')

  billing_addr.hide() unless $('#billing_address input:radio[value=custom]').is ':checked'
  payee_addr.hide() unless $('#payee_address input:radio[value=custom]').is ':checked'

  $('#billing_address input:radio').change ->
    radio = $(this)
    if radio.is ':checked'
      if radio.val() == 'custom'
        billing_addr.show()
      else
        billing_addr.hide()

  $('#payee_address input:radio').change ->
    radio = $(this)
    if radio.is ':checked'
      if radio.val() == 'custom'
        payee_addr.show()
      else
        payee_addr.hide()
