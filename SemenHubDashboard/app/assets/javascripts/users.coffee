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

  # Show

  $('.edit-commission').on 'click', (event) ->
    original = $('.commission > .percent').text()
    $('.commission > .percent').text ''
    $('<input type="text" name="commission-percent">').appendTo($('.commission > .percent')).val(original)
    $('.edit-commission').hide()
    save_button = $('<span>').addClass("save-commission").addClass("link").text 'Save'
    cancel_button = $('<span>').addClass("cancel-button").addClass("link").text 'Cancel'
    save_button.appendTo($('.commission'))
    save_button.on 'click', (event) ->
      $.ajax
        url: window.location.href + "/commission"
        dataType: "json"
        type: "POST"
        data: {commission_percent: $('input[name="commission-percent"]').val()}
        error: (xhr, textStatus, error) -> 
          alert "an error occured \"" + error + "\""
        success: (data, textStatus, xhr) ->
          $('input[name="commission-percent"]').remove()
          $('.save-commission').remove()
          $('.reset-commission').remove()
          $('.cancel-button').remove()
          $('.edit-commission').show()
          $('.commission > .percent').text(data.commission_percent)
    cancel_button.appendTo($('.commission'))
    cancel_button.on 'click', (event) ->
      $('.save-commission').remove()
      $('.reset-commission').remove()
      $('.cancel-button').remove()
      $('input[name="commission-percent"]')
      $('.edit-commission').show()
      $('.commission > .percent').text(original)

