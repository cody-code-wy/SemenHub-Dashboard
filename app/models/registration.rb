class Registration < ApplicationRecord
  belongs_to :registrar
  belongs_to :animal, touch: true

  validates :registration, presence: true
end
