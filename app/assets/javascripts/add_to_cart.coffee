$(document).on 'skus:show', ->
  $(".add_to_cart").on 'click', ->
    updateData = {'skus': {"#{$("body").data("params-id")}": "#{$("#sku_quantity").val()}"}}
    $.post('/cart/update', updateData, addedToCart, 'json')

  addedToCart = ->
    alert("Added to cart")
