class Permission < ApplicationRecord
  validates_presence_of :name, :description
  validates_uniqueness_of :name

  has_many :permission_assignments, dependent: :destroy
  has_many :roles, through: :permission_assignments
end
