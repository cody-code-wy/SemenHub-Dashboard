class InventoryTransaction < ApplicationRecord
  belongs_to :animal
  belongs_to :storageFacility
end
