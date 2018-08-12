json.array! @skus do |sku|
  json.partial! "skus/sku", sku: sku
  json.quantity @quantities[sku.id]
end
