require 'rails_helper'

RSpec.describe RoleAssignment, type: :model do

  it 'should have a valid fatory' do
    expect(FactoryBot.build(:role_assignment)).to be_valid
  end

  describe 'Validations' do
    it 'should not be valid without user' do
      expect(FactoryBot.build(:role_assignment, user: nil)).to_not be_valid
    end
    it 'should not be valid without role' do
      expect(FactoryBot.build(:role_assignment, role: nil)).to_not be_valid
    end
  end

  describe 'Relations' do
    it 'should have a User' do
      expect(FactoryBot.build(:role_assignment).user).to be_a User
    end
    it 'should have a Role' do
      expect(FactoryBot.build(:role_assignment).role).to be_a Role
    end
  end
end
