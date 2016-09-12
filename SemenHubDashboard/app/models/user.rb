class User < ApplicationRecord
  belongs_to :billing_address, class_name: 'Address'
  belongs_to :mailing_address, class_name: 'Address'
  belongs_to :payee_address, class_name: 'Address', required: false
end
