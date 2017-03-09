class StorageFacility < ApplicationRecord
  belongs_to :address
  has_many :fees

  validates_presence_of :phone_number, :website, :name
  validates :email, presence: true, email: true
end
