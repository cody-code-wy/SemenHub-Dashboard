class Animal < ApplicationRecord
  belongs_to :breed
  belongs_to :owner, class_name: 'User'

  validates_presence_of :registration_type, :registration, :name, :owner, :breed
end
