class Registrar < ApplicationRecord
  belongs_to :breed
  belongs_to :address

  has_many :registrations

  validates :name, presence: true
  validates :phone_primary, presence: true
  validates :email, presence: true
  validates :website, presence: true
end
