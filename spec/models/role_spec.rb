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
    before do
      @role = FactoryBot.build(:role, :with_permissions, :with_users)
    end
    it 'should have permission_assignments' do
      expect(@role.permission_assignments.first).to be_a PermissionAssignment
    end
    it 'should have permission thru permission_assignmnets' do
      expect(@role.permissions.first).to be_a Permission
    end
    it 'should belong to role_assignments' do
      expect(@role.role_assignments.first).to be_a RoleAssignment
    end
    it 'should belong to users thru role_assignments' do
      expect(@role.users.first).to be_a User
    end
  end
end
