class Registration < ApplicationRecord

  belongs_to :registrar
  belongs_to :animal, touch: true

  validates_presence_of :registration

end
