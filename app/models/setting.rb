class Setting < ApplicationRecord

  enum setting: {add_to_cart_buttons_enabled: 0, checkout_button_enabled: 1, remote_account_access_buttons_enabled: 2, credit_card_processing_enabled: 3}

  validates_presence_of :setting
  validates_uniqueness_of :setting

end
