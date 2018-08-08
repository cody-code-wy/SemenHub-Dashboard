$(document).on 'cart:show', ->
  $('#update_cart_button').on 'click', ->
    skuQuantities = {}
    updateData = {'skus': skuQuantities}
    $('.quantity_field').each (index, value) ->
      skuQuantities["#{$(this).data('sku-id')}"] = $(this).val()
    $.post('/cart/update', updateData, updateCart, 'json')

  error = (response, status, thrown) ->
    console.log thrown
    console.log status
    console.log response

  updateCart = (data, status, response) ->
    $(data).each (property, value) ->
      console.log "Updating #{value['id']} to #{value['quantity']}"
      $("#quantity_sku_#{value['id']}").val(value['quantity'])

  startCartUpdate = ->
    $.get('/cart', updateCart, 'json')

