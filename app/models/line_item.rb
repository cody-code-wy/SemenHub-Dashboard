class LineItem < ApplicationRecord
  belongs_to :purchase, touch: true

  validates :name, presence: true
  validates :value, presence: true
  validates :purchase, presence: true
end
