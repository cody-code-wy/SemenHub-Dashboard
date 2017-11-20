require 'rails_helper'

RSpec.describe Role, type: :model do

  it 'should have a vaild factory' do
    expect(FactoryBot.build(:role)).to be_valid
  end

  describe 'Validations' do
    it 'should be invalid without a name' do
      expect(FactoryBot.build(:role, name: nil)).to_not be_valid
    end
  end

  describe 'Relations' do
    it 'should have permission_assignments'
    it 'should have permission thru permission_assignmnets'
    it 'should belong to role_assignments'
    it 'should belong to users thru role_assignments'
  end
end
