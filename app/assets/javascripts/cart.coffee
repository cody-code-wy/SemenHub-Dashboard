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
    $('.quantity_field').each ->
      target_id = $(this).data('sku-id')
      found = (sku for sku in data when sku.id is target_id)[0]
      if found
        console.log "Updating #{target_id} to #{found.quantity}"
        $(this).val(found.quantity)
      else
        console.log "Removing #{target_id} from table"
        row = $(this).parent().parent()
        table = $('table')
        row.remove()
        table.trigger('update').trigger('sorton', table.get(0).config.sortList).trigger('appendCache').trigger('applyWidgets')

  startCartUpdate = ->
    $.get('/cart', updateCart, 'json')

