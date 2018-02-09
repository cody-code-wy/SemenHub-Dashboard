class Setting < ApplicationRecord
  enum setting: {
      add_to_cart_buttons_enabled: 0,
      checkout_button_enabled: 1,
      remote_account_access_buttons_enabled: 2,
      credit_card_processing_enabled: 3,
      send_purchase_emails: 4
  }

  validates :setting, presence: true, uniqueness: true
  validates :value, presence: true

  def self.get_setting(selected_setting)
    setting = where(setting: selected_setting).first
    setting ||= new(setting: selected_setting, value: DEFAULT_SETTINGS[selected_setting.to_s])
  end

end
