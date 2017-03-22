class SettingsController < ApplicationController

  def index
    @settings = Setting.all
  end

  def update
    Setting.settings.keys.each do |key|
      Setting.get_setting(key).update(get_setting_params.require(key).permit(:value))
    end
    # byebug
    redirect_to Setting
  end

  private

  def get_setting_params
    params.require(:settings)
  end

end
