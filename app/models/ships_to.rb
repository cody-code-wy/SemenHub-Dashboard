class ShipsTo < ApplicationRecord
  belongs_to :country, foreign_key: 'alpha_2', primary_key: 'alpha_2'
  belongs_to :sku
end
