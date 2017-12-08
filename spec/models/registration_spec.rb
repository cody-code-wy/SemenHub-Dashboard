require 'rails_helper'

RSpec.describe Registration, type: :model do
  it 'should have a valid factory' do
    expect(FactoryBot.build(:registration)).to be_valid
  end

  describe 'Validations' do
    it 'should be invalid without registrar' do
      expect(FactoryBot.build(:registration, registrar: nil)).to_not be_valid
    end
    it 'should be invalid without animal' do
      expect(FactoryBot.build(:registration, animal: nil)).to_not be_valid
    end
    it 'should be invalid without registration' do
      expect(FactoryBot.build(:registration, registration: nil)).to_not be_valid
    end
    it 'should be valid without ai_certification' do
      expect(FactoryBot.build(:registration, ai_certification: nil)).to be_valid
    end
    it 'should be valid without note' do
      expect(FactoryBot.build(:registration, note: nil)).to be_valid
    end
  end

  describe 'Relations' do
    before do
      @registration = FactoryBot.build(:registration)
    end
    it 'should have a Registrar' do
      expect(@registration.registrar).to be_a Registrar
    end
    it 'should have an Animal' do
      expect(@registration.animal).to be_an Animal
    end
    it 'should touch Animal' do
      @registration.save()
      expect{
        @registration.update({note: Faker::Lorem.words(10).join(' ')})
      }.to change {
        @registration.reload()
        @registration.animal.updated_at
      }
    end
  end
end
