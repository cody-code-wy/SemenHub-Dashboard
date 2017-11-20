require 'rails_helper'

RSpec.describe Country, type: :model do

  describe 'Seeds' do
    it 'should have US from seeds' do
      expect(Country.find_by_alpha_2('us')).to be_truthy
    end
  end

  it 'should have a valid factory' do
    expect(FactoryBot.build(:country)).to be_valid
  end

  describe 'Validations' do
    it 'should be invalid without name' do
      expect(FactoryBot.build(:country, name: nil)).to_not be_valid
    end

    it 'should be invalid without alpha_2' do
      expect(FactoryBot.build(:country, alpha_2: nil)).to_not be_valid
    end

    it 'should be invalid with duplicate alpha_2' do
      expect(FactoryBot.build(:country, alpha_2: 'us')).to_not be_valid
    end
  end

end
