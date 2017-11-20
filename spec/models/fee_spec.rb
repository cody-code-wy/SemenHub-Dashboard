require 'rails_helper'

RSpec.describe Fee, type: :model do

  it 'should have a valid factory' do
    expect(FactoryBot.build(:fee)).to be_valid
  end

  describe 'Validations' do
    it 'should not be valid without price' do
      expect(FactoryBot.build(:fee, price: nil)).to_not be_valid
    end
    it 'should not be valid without fee_type' do
      expect(FactoryBot.build(:fee, fee_type: nil)).to_not be_valid
    end
    it 'should not be valid without storage facility' do
      expect(FactoryBot.build(:fee, storage_facility: nil)).to_not be_valid
    end
  end

  describe 'Relations' do
    it 'should have a StorageFacility' do
      expect(FactoryBot.build(:fee).storage_facility).to be_a StorageFacility
    end
  end

  it 'fee_type should be in the enum' do
    Fee.fee_types.each do |type, num|
      expect(FactoryBot.build(:fee, fee_type: type)).to be_valid
    end
  end

end
