class Commission < ApplicationRecord
  belongs_to :user

  validates_presence_of :commission_percent
end
