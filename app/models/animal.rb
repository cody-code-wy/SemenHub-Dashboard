class Animal < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  belongs_to :breed

  has_many :registrations
  has_many :skus

  validates :name, presence: true

  def get_drop_down_name
    "#{name} - #{owner.first_name} #{owner.last_name}"
  end
end
