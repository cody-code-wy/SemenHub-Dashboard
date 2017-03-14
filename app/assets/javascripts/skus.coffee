$(document).on 'turbolinks:load', ->

  getCost = () ->
    price_per_unit = $('#sku_price_per_unit').val()
    commission = $('#sku_commission').val()
    $('#sku_cost_per_unit').val((price_per_unit - (price_per_unit * commission / 100)).toFixed(2))

  getCommission = () ->
    price_per_unit = $('#sku_price_per_unit').val()
    cost_per_unit = $('#sku_cost_per_unit').val()
    $('#sku_commission').val(((price_per_unit - cost_per_unit) / price_per_unit * 100).toFixed(2))

  onChange = () ->
    check = $('#sku_commission_selector_user_commission')
    $('#sku_cost_per_unit, #sku_commission, #sku_price_per_unit').off().removeAttr('readonly')
    $('#sku_has_percent').val(false)
    if check.is ':checked'
      $('#commission_table').hide()
      $('#sku_cost_per_unit').val("")
      $('#sku_commission').val("10")
    else
      value = $('input:radio').filter(':checked').val()
      console.log(value)
      $('#commission_table').show()
      if value == "custom_commission"
        $('#sku_commission, #sku_price_per_unit').on 'keyup', getCost
        getCost()
        $('#sku_cost_per_unit').attr('readonly','')
        $('#sku_has_percent').val(true)
      else
        $('#sku_cost_per_unit, #sku_price_per_unit').on 'keyup', getCommission
        getCommission()
        $('#sku_commission').attr('readonly','')


  $('input:radio').change onChange
  getCommission() #If a cost_per_unit is provided we need to get commission before we do anything or it will be deleted!
  onChange()
