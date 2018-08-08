$(document).on 'skus:show', ->
  $(".add_to_cart").on 'click', ->
    sku = $(this).data("sku-id")
    updateData = {'skus': {"#{sku}": "#{$("##{sku}_quantity").val()}"}}
    $.post('/cart/update', updateData, addedToCart, 'json')

  addedToCart = ->
    alert("Added to cart")
