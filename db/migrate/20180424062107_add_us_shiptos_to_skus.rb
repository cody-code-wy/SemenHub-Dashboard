class AddUsShiptosToSkus < ActiveRecord::Migration[5.0]
  def up
    Sku.all.each do |sku|
      ShipsTo.create(sku: sku, alpha_2: 'us')
    end
  end
end
