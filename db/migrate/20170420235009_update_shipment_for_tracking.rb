class UpdateShipmentForTracking < ActiveRecord::Migration[5.0]

  class Shipment < ApplicationRecord
    belongs_to :purchase
  end

  class PurchaseTransaction < ApplicationRecord
    belongs_to :inventory_transaction
  end

  class InventoryTransaction < ApplicationRecord
    belongs_to :sku, touch: true
  end

  class Sku < ApplicationRecord
    belongs_to :storagefacility, class_name: 'StorageFacility'
  end

  class StorageFacility < ApplicationRecord
    belongs_to :address
  end

  class Address  < ApplicationRecord

  end

  class Purchase < ApplicationRecord
    has_many :purchase_transactions
    has_many :inventory_transactions, through: :purchase_transactions
    has_many :skus, through: :inventory_transactions
    has_many :storagefacilities, through: :skus
    has_many :shipments
  end

  def change
    change_table :shipments do |t|
      t.references :origin_address, references: :address
      t.string :origin_name
      t.string :origin_account
      t.string :tracking_number
    end
    reversible do |change|
      change.up do
        up
      end

      change.down do
        down
      end
    end
  end

  def up
    rename_column :shipments, :method, :shipping_provider
    Shipment.all.each do |shipment|
      shipment.destroy
      purchase = shipment.purchase
      shipment.purchase.storagefacilities.uniq.each do |storage|
        purchase.shipments << Shipment.new(
          location_name: shipment.location_name,
          account_name: shipment.account_name,
          address_id: shipment.address_id,
          shipping_provider: storage.shipping_provider,
          origin_address_id: storage.address_id,
          origin_name: storage.name,
          origin_account: 'Craig Perez (SemenHub)'
        )
      end
    end
  end

  def self.down
    change_column :shipments, :shipping_provider, :method
  end
end
