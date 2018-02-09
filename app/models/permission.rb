class Permission < ApplicationRecord
  has_many :permission_assignments, dependent: :destroy
  has_many :roles, through: :permission_assignments

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end
