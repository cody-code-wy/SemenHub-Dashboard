class StorageFacility < ApplicationRecord
  belongs_to :address

  require :name
end
