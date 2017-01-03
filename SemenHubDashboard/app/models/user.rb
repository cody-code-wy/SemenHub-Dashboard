class User < ApplicationRecord
  belongs_to :billing_address, class_name: 'Address'
  belongs_to :mailing_address, class_name: 'Address'
  belongs_to :payee_address, class_name: 'Address', required: false

  has_one :commission, class_name: 'Commission' # class_name required due to rails bug

  has_many :purchases
  has_many :animals, foreign_key: 'owner_id'

  validates_presence_of :first_name, :last_name, :email, :phone_primary

  validates_uniqueness_of :email

  def get_name
    "#{first_name} #{last_name}"
  end
end
