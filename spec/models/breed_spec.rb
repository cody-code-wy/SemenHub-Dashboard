require 'rails_helper'

RSpec.describe Breed, type: :model do
  it 'should have a valid factory' do
    expect( FactoryBot.build(:breed) ).to be_valid
  end

  describe 'Validations' do
    it 'should be invalid without breed_name' do
      expect( FactoryBot.build(:breed, breed_name: nil) ).to_not be_valid
    end
  end

  describe 'Relations' do
    it 'Should have registrars of type Registrar'
  end
end
