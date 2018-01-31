class Country < ApplicationRecord
  has_many :addresses, foreign_key: 'alpha_2', primary_key: 'alpha_2'

  validates :alpha_2, uniqueness: true, presence: true
  validates :name, presence: true
end
