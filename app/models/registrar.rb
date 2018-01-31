class Registrar < ApplicationRecord

  has_many :registrations
  belongs_to :breed
  belongs_to :address

  validates_presence_of :name, :phone_primary, :email, :website

end
