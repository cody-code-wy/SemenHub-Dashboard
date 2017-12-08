require 'rails_helper'

RSpec.describe Animal, type: :model do

  describe 'Factory' do
    it 'should have a valid factory' do
      expect(FactoryBot.build(:animal)).to be_valid
    end
    it 'should have a valid factory :with_registrations' do
      expect(FactoryBot.build(:animal, :with_registrations)).to be_valid
    end
  end

  describe 'Validations' do
    it 'should not be valid without name' do
      expect(FactoryBot.build(:animal, name: nil)).to_not be_valid
    end
    it 'should not be valid without an owner' do
      expect(FactoryBot.build(:animal, owner: nil)).to_not be_valid
    end
    it 'should not be valid without a breed' do
      expect(FactoryBot.build(:animal, breed: nil)).to_not be_valid
    end
    it 'should be valid without private_herd_number' do
      expect(FactoryBot.build(:animal, private_herd_number: nil)).to be_valid
    end
    it 'should be valid without dna_number' do
      expect(FactoryBot.build(:animal, dna_number: nil)).to be_valid
    end
    it 'should be valid without description' do
      expect(FactoryBot.build(:animal, description: nil)).to be_valid
    end
    it 'should be valid without notes' do
      expect(FactoryBot.build(:animal, notes: nil)).to be_valid
    end
  end

  describe 'Relations' do
    before do
      @animal = FactoryBot.build(:animal, :with_registrations)
    end
    it 'should have a Owner of type User' do
      expect(@animal.owner).to be_a User
    end
    it 'should have a Breed' do
      expect(@animal.breed).to be_a Breed
    end
    it 'should have registrations' do
      expect(@animal.registrations.first).to be_a Registration
    end
    it 'should have SKUs of type SKU'
  end

  describe 'get_drop_down_name' do
    before do
      @owner = FactoryBot.build(:user, first_name: 'first_name', last_name: 'last_name')
      @animal = FactoryBot.build(:animal, name: 'animal_name', owner: @owner)
    end
    it 'should return the correct order' do
      expect(@animal.get_drop_down_name).to eq "animal_name - first_name last_name"
    end
  end
end
