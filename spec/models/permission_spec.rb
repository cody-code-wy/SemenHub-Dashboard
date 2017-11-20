require 'rails_helper'

RSpec.describe Permission, type: :model do

  it 'should have a valid factory' do
    expect(FactoryBot.build(:permission)).to be_valid
  end

  describe 'Validations' do
    it 'should be invalid without name' do
      expect(FactoryBot.build(:permission, name: nil)).to_not be_valid
    end
    it 'should be invalid without description' do
      expect(FactoryBot.build(:permission, description: nil)).to_not be_valid
    end
  end

  describe 'Relations' do
    it 'should belong to permission_assignments'
    it 'should belong to roles thru permission_assignments'
  end
end
