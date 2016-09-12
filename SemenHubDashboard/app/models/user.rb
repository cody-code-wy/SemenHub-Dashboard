class User < ApplicationRecord
  belongs_to :billing_address, class_name: 'Address'
  belongs_to :mailing_address, class_name: 'Address'
  belongs_to :payee_address, class_name: 'Address', required: false

  has_one :commission, class_name: 'Commission' # class_name required due to rails bug

  has_many :purchases
end
