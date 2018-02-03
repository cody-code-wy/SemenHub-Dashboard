class Commission < ApplicationRecord
  belongs_to :user

  validates_presence_of :commission_percent
  validates :commission_percent, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
