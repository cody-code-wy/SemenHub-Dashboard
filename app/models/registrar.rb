class Registrar < ApplicationRecord

  has_many :registrations
  belongs_to :breed
  belongs_to :address

end