require 'rails_helper'

RSpec.describe Address, type: :model do

  it 'should have a valid factory' do
    expect(FactoryBot.build(:address)).to be_valid
  end

  describe 'Validations' do
    it 'should be invalid without line1' do
      expect(FactoryBot.build(:address, line1: nil)).to_not be_valid
    end

    it 'should be valid without line2' do
      expect(FactoryBot.build(:address, line2: nil)).to be_valid
    end

    it 'should be invalid without postal_code' do
      expect(FactoryBot.build(:address, postal_code: nil)).to_not be_valid
    end

    it 'should be invalid without city' do
      expect(FactoryBot.build(:address, city: nil)).to_not be_valid
    end

    it 'should be invalid without region' do
      expect(FactoryBot.build(:address, region: nil)).to_not be_valid
    end

    it 'should be invalid without alpha_2' do
      expect(FactoryBot.build(:address, alpha_2: nil)).to_not be_valid
    end

  end

  describe 'Relations' do
    it 'should have a country' do
       expect(FactoryBot.build(:address).country).to be_a Country
    end
  end

  describe 'UPS API integration' do

    it 'get_shipping_location should return a ActiveShipping::Location' do
      expect(FactoryBot.build(:address).get_shipping_location).to be_a ActiveShipping::Location
    end

    it 'validate_address should be vaild for know good address' do
      expect(FactoryBot.build(:address, :known_good).is_valid_address).to be true
    end
  end
end
