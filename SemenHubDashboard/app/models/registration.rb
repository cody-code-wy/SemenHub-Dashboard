class Registration < ApplicationRecord

  belongs_to :registrar
  has_many :animals

end