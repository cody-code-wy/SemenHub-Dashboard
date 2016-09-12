class Country < ApplicationRecord
  has_many :addresses, foreign_key: 'alpha_2', primary_key: 'alpha_2'
end
