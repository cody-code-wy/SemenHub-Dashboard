class Role < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :role_assignments
  has_many :users, through: :role_assignments
end
