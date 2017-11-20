require 'rails_helper'

RSpec.describe Setting, type: :model do
  it 'should have a valid factory' do
    expect(FactoryBot.build(:setting)).to be_valid
  end

  describe 'Validations' do
    it 'should not be valid without setting' do
      expect(FactoryBot.build(:setting, setting: nil)).to_not be_valid
    end
    it 'should not be valid without value' do
      expect(FactoryBot.build(:setting, value: nil)).to_not be_valid
    end
    it 'should not be valid with duplicate setting' do
      @setting = FactoryBot.create(:setting)
      expect(FactoryBot.build(:setting, setting: @setting.setting)).to_not be_valid
    end
  end

  it 'setting should be in the setting enum' do
    Setting.settings.each do |setting, num|
      expect(FactoryBot.build(:setting, setting: setting)).to be_valid
    end
  end

  it 'should properly load defaults from the file' do
    DEFAULT_SETTINGS.each do |setting, expected|
      expect(Setting.get_setting(setting).value).to eq expected
    end
  end

  it 'should properly load settings from db with get_setting' do
    Setting.settings.each do |setting, num|
      FactoryBot.create(:setting, setting: setting, value: "#{num}")
    end
    Setting.settings.each do |setting, num|
      expect(Setting.get_setting(setting).value).to eq "#{num}"
    end
  end


end
