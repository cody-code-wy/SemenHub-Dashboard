class Breed < ApplicationRecord

  validates_presence_of :breed_name
  has_many :registrars

end
