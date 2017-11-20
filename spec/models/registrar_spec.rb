require 'rails_helper'

RSpec.describe Registrar, type: :model do

  it 'should have a valid factory' do
    expect(FactoryBot.build(:registrar)).to be_valid
  end

  describe 'Validations' do
    it 'should not be valid without breed' do
      expect(FactoryBot.build(:registrar, breed: nil)).to_not be_valid
    end
    it 'should not be valid without address' do
      expect(FactoryBot.build(:registrar, address: nil)).to_not be_valid
    end
    it 'should not be valid without name' do
      expect(FactoryBot.build(:registrar, name: nil)).to_not be_valid
    end
    it 'should not be valid without phone_primary' do
      expect(FactoryBot.build(:registrar, phone_primary: nil)).to_not be_valid
    end
    it 'should not be valid without email' do
      expect(FactoryBot.build(:registrar, email: nil)).to_not be_valid
    end
    it 'should not be valid without website' do
      expect(FactoryBot.build(:registrar, website: nil)).to_not be_valid
    end
    it 'should be valid without phone_secondary' do
      expect(FactoryBot.build(:registrar, phone_secondary: nil)).to be_valid
    end
    it 'should be valid without note' do
      expect(FactoryBot.build(:registrar, note: nil)).to be_valid
    end
  end

  describe 'Relations' do
    before do
      @registrar = FactoryBot.build(:registrar)
    end
    it 'should have an Address' do
      expect(@registrar.address).to be_a Address
    end
    it 'should have a Breed' do
      expect(@registrar.breed).to be_a Breed
    end
    it 'should have registrations of type Registration'
  end
end
