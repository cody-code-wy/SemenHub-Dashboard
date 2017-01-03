class Animal < ApplicationRecord
  has_many :registrations
  belongs_to :owner, class_name: 'User'
  belongs_to :breed

  validates_presence_of :name, :owner
end
