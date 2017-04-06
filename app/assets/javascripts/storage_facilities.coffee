# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->

  getPrice = (price) ->
    (price / 100).toFixed 2

  updateCost = () ->
    $('.test-span').text("Loading")
    dest = $('#storagefacility_id').find('option:selected').attr('value')
    $.getJSON("#{document.location.href}/test", {dest: dest}).done (jd) ->
      $('.test-total').text("$#{getPrice(jd.total)}")
      $('.test-out').text("$#{getPrice(jd.out_price)}")
      $('.test-in').text("$#{getPrice(jd.in_price)}")

  $('#storagefacility_id').on 'change', updateCost
  updateCost()

