# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->

  getPrice = (price, div=100) ->
    (price / div).toFixed 2

  updateCost = () ->
    $('.test-span').text("Loading")
    total = 0
    $('.fee-price').each () ->
      total += parseFloat($(this).text())
    $('.test-fees').text("$#{getPrice(total,1)}")
    dest = $('#storagefacility_id').find('option:selected').attr('value')
    $.getJSON("#{document.location.href}/test", {dest: dest}).done (jd) ->
      $('.test-total').text("$#{getPrice(jd.total + (total * 100))}")
      $('.test-shipping').text("$#{getPrice(jd.total)}")
      $('.test-out').text("$#{getPrice(jd.out_price)}")
      $('.test-in').text("$#{getPrice(jd.in_price)}")

  removeRow = (e, data, status, xhr) ->
    $(this).parent().parent().remove()
    updateCost()

  $('#storagefacility_id').on 'change', updateCost
  updateCost()

  $('#new_fee').on 'ajax:success', (e, data, status, xhr) ->
    console.log(data)
    table = $('.fees table tbody')
    row = $('<tr></tr>')
    show = $('<a></a>').attr('href',data.url).text("Show fee").appendTo($('<td></td>').appendTo(row))
    del = $('<a></a>').attr('href',data.url).attr('data-type','json').attr('data-remote','true').attr('rel','nofollow').attr('data-method','delete').text("Delete fee").on('ajax:success', removeRow).appendTo($('<td></td>').appendTo(row))
    type = $('<td></td>').text(data.fee_type).appendTo(row)
    price = $('<td></td>').addClass("fee-price").text(data.price).appendTo(row)
    table.append(row).trigger('addRows', [row, true])
    updateCost()


  $("a[data-method='delete']").on 'ajax:success', removeRow


