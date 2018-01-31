class Breed < ApplicationRecord
  has_many :registrars

  validates :breed_name, presence: true
end
