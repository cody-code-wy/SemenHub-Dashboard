require 'rails_helper'

RSpec.describe PermissionAssignment, type: :model do

  it 'should have a valid fatory' do
    expect(FactoryBot.build(:permission_assignment)).to be_valid
  end

  describe 'Validations' do
    it 'should be invalid without a Role' do
      expect(FactoryBot.build(:permission_assignment, role: nil)).to_not be_valid
    end
    it 'should be invalid without a Permission' do
      expect(FactoryBot.build(:permission_assignment, permission: nil)).to_not be_valid
    end
  end

  describe 'Relations' do
    it 'should have a Role' do
      expect(FactoryBot.build(:permission_assignment).role).to be_a Role
    end
    it 'should have a Permission' do
      expect(FactoryBot.build(:permission_assignment).permission).to be_a Permission
    end
  end
end
