require 'rails_helper'

RSpec.describe ShipsTo, type: :model do
  describe 'Factory' do
    it 'should have a valid factary' do
      expect(FactoryBot.build(:ships_to)).to be_valid
    end
  end
  describe 'Validations' do
    it 'should be invalid without a country' do
      expect(FactoryBot.build(:ships_to, country: nil)).to_not be_valid
    end
    it 'should be invalid without a sku' do
      expect(FactoryBot.build(:ships_to, sku: nil)).to_not be_valid
    end
  end
  describe 'Relations' do 
    it 'should have a country' do
      expect(FactoryBot.build(:ships_to).country).to be_a Country
    end
    it 'should have a sku' do
      expect(FactoryBot.build(:ships_to).sku).to be_a Sku
    end
  end
end
