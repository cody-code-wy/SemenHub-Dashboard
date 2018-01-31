require 'rails_helper'

RSpec.describe Shipment, type: :model do
  it 'should have a valid factory' do
    expect(FactoryBot.build(:shipment)).to be_valid
  end

  describe 'Validations' do
    it 'should be invalid without purchase' do
      expect(FactoryBot.build(:shipment, purchase: nil)).to_not be_valid
    end
    it 'should be invalid without shipping_provider' do
      expect(FactoryBot.build(:shipment, shipping_provider: nil)).to_not be_valid
    end
    it 'should be valid without requested_date' do
      expect(FactoryBot.build(:shipment, requested_date: nil)).to be_valid
    end
    it 'should be valid without location_name' do
      expect(FactoryBot.build(:shipment, location_name: nil)).to be_valid
    end
    it 'should be valid without account_name' do
      expect(FactoryBot.build(:shipment, account_name: nil)).to be_valid
    end
    it 'sohuld be invalid without address' do
      expect(FactoryBot.build(:shipment, address: nil)).to_not be_valid
    end
    it 'should be invalid without origin_address' do
      expect(FactoryBot.build(:shipment, origin_address: nil)).to_not be_valid
    end
    it 'should be invalid without origin_name' do
      expect(FactoryBot.build(:shipment, origin_name: nil)).to_not be_valid
    end
    it 'should be valid without origin_account' do
      expect(FactoryBot.build(:shipment, origin_account: nil)).to be_valid
    end
    it 'should be valid without tracking number' do
      expect(FactoryBot.build(:shipment, tracking_number: nil)).to be_valid
    end
    it 'should be valid without phone_number' do
      expect(FactoryBot.build(:shipment, phone_number: nil)).to be_valid
    end
  end

  describe 'Relations' do
    it 'should have a Purchase' do
      expect(FactoryBot.build(:shipment).purchase).to be_a Purchase
    end
    it 'should have an Address' do
      expect(FactoryBot.build(:shipment).address).to be_an Address
    end
    it 'should have a origin_address as Address' do
      expect(FactoryBot.build(:shipment).origin_address).to be_an Address
    end
  end

  it 'shipping_provider should be in the enmu' do
    Shipment.shipping_providers.each do |type, num|
      expect(FactoryBot.build(:shipment, shipping_provider: type)).to be_valid
    end
  end
end
