require 'rails_helper'

RSpec.describe Commission, type: :model do

  it 'should have a valid factory' do
    expect(FactoryBot.build(:commission)).to be_valid
  end

  describe 'Validations' do
    it 'should be invalid without user' do
      expect(FactoryBot.build(:commission, :without_user)).to_not be_valid
    end

    it 'should be invalid without commission_percent' do
      expect(FactoryBot.build(:commission, commission_percent: nil)).to_not be_valid
    end

    it 'should be invalid with commission_percent below 0' do
      expect(FactoryBot.build(:commission, commission_percent: -1)).to_not be_valid
    end

    it 'should be invalid with commission_percent above 100' do
      expect(FactoryBot.build(:commission, commission_percent: 101)).to_not be_valid
    end
  end

  describe 'Relations' do
    it 'should have a User' do
      expect(FactoryBot.build(:commission).user).to be_a User
    end
  end
end
