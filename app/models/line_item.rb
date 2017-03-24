class LineItem < ApplicationRecord

  belongs_to :purchase, touch: true

  validates_presence_of :name, :value, :purchase

end
