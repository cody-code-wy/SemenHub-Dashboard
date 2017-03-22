class LineItem < ApplicationRecord

  belongs_to :purchase

  validates_presence_of :name, :value, :purchase

end
