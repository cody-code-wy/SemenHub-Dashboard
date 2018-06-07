require 'rails_helper'

RSpec.describe Animal, type: :model do

  describe 'Factory' do
    it 'should have a valid factory' do
      expect(FactoryBot.build(:animal)).to be_valid
    end
    it 'should have a valid factory :with_registrations' do
      expect(FactoryBot.build(:animal, :with_registrations)).to be_valid
    end
    it 'should have a valid factory :with_skus' do
      expect(FactoryBot.build(:animal, :with_skus)).to be_valid
    end
    it 'should have a valid factory :with_dam' do
      expect(FactoryBot.build(:animal, :with_dam)).to be_valid
    end
    it 'should have a valid factory :with_sire' do
      expect(FactoryBot.build(:animal, :with_sire)).to be_valid
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
    it 'should not be valid without is_male set' do
      expect(FactoryBot.build(:animal, is_male: nil)).to_not be_valid
    end
    it 'sholud not be valid with male dam' do
      expect(FactoryBot.build(:animal, dam: FactoryBot.build(:animal, is_male: true))).to_not be_valid
    end
    it 'should not be valid with female sire' do
      expect(FactoryBot.build(:animal, sire: FactoryBot.build(:animal, is_male: false))).to_not be_valid
    end
    it 'should not be valid with different breed sire' do
      @b1 = FactoryBot.create(:breed).id
      @b2 = FactoryBot.create(:breed).id
      expect(FactoryBot.build(:animal, breed_id: @b1, sire: FactoryBot.build(:animal, is_male: true, breed_id: @b2))).to_not be_valid
    end
    it 'should not be valid with different breed dam' do
      @b1 = FactoryBot.create(:breed).id
      @b2 = FactoryBot.create(:breed).id
      expect(FactoryBot.build(:animal, breed_id: @b1, dam: FactoryBot.build(:animal, is_male: false, breed_id: @b2))).to_not be_valid
    end
    it 'should be valid with is_male false' do #if presence valdator is used this will fail
      expect(FactoryBot.build(:animal, is_male: false)).to be_valid
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
    it 'should be valid without dam' do
      expect(FactoryBot.build(:animal, dam: nil)).to be_valid
    end
    it 'should be valid without sire' do
      expect(FactoryBot.build(:animal, sire: nil)).to be_valid
    end
    it 'should be valid without date of birth' do
      expect(FactoryBot.build(:animal, date_of_birth: nil)).to be_valid
    end
  end

  describe 'Relations' do
    before do
      @animal = FactoryBot.build(:animal, :with_registrations, :with_skus, :with_sire, :with_dam)
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
    it 'should have SKUs of type SKU' do
      expect(@animal.skus.first).to be_a Sku
    end
    it 'should havea dam of type Animal' do
      expect(@animal.dam).to be_an Animal
    end
    it 'should have a sire of type Animal' do
      expect(@animal.sire).to be_an Animal
    end
  end

  describe 'Database Interaction' do
    it 'should keep is_male false after being loaded from database' do #on some db systems a default value on bools will overwrite false with the default
      FactoryBot.create(:animal, is_male: false)
      expect(Animal.last.is_male).to be false
    end
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
