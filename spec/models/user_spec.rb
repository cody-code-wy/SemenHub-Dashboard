require 'rails_helper'

RSpec.describe User, type: :model do

  it 'should have a valid factory' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  describe 'Validations' do
    it 'should not be valid without first_name' do
      expect(FactoryBot.build(:user, first_name: nil)).to_not be_valid
    end

    it 'should not be valid without last_name' do
      expect(FactoryBot.build(:user, last_name: nil)).to_not be_valid
    end

    it 'should be valid without spouse_name' do
      expect(FactoryBot.build(:user, spouse_name: nil)).to be_valid
    end

    it 'should not be valid without email' do
      expect(FactoryBot.build(:user, email: nil)).to_not be_valid
    end

    it 'should not be valid without phone_primary' do
      expect(FactoryBot.build(:user, phone_primary: nil)).to_not be_valid
    end

    it 'should be valid without phone_secondary' do
      expect(FactoryBot.build(:user, phone_secondary: nil)).to be_valid
    end

    it 'should be valid without website' do
      expect(FactoryBot.build(:user, website: nil)).to be_valid
    end

    it 'should not be valid without mailing_address' do
      expect(FactoryBot.build(:user, mailing_address: nil)).to_not be_valid
    end

    it 'should not be valid without billing_address' do
      expect(FactoryBot.build(:user, billing_address: nil)).to_not be_valid
    end

    it 'should be vaild without payee_address' do
      expect(FactoryBot.build(:user, payee_address: nil)).to be_valid
    end

    it 'should not be valid without password / password_confirmation' do
      expect(FactoryBot.build(:user, password: nil, password_confirmation: nil)).to_not be_valid
    end

    it 'should not be valid with non-matching password and password_confirmation' do
      expect(FactoryBot.build(:user, password: '12345678', password_confirmation: '87654321')).to_not be_valid
    end

    it 'should not be valid with password shorter than 8 chars' do
      expect(FactoryBot.build(:user, password: '1234567', password_confirmation: '1234567')).to_not be_valid
    end

    it 'should be valid with password equal to or longer than 8 chars' do
      expect(FactoryBot.build(:user, password: '12345678', password_confirmation: '12345678')).to be_valid
    end

    it 'should not be valid with duplicate email' do
      user = FactoryBot.create(:user)
      expect(FactoryBot.build(:user, email: user.email)).to_not be_valid
    end

    it 'should not be valid with malformed email' do
      expect(FactoryBot.build(:user, email: "not an email")).to_not be_valid
    end
  end

  describe 'Relations' do
    before do
      @user = FactoryBot.build(:user)
    end
    it 'should have billing_address of type Address' do
      expect(@user.billing_address).to be_a Address
    end
    it 'should have mailing_address of type Address' do
      expect(@user.mailing_address).to be_a Address
    end
    it 'should have payee_address of type Address' do
      expect(@user.payee_address).to be_a Address
    end
    it 'should have purchases of type Purchase'
    it 'should have animals of type Animal'
    it 'should have role_assignments of type RoleAssignment' do
      @user.roles << Role.find_by_name("superuser") # Give roles and permissions
      expect(@user.role_assignments.first).to be_a RoleAssignment
    end
    it 'should have roles through role_assignments of type Role' do
      @user.roles << Role.find_by_name("superuser") # Give roles and permissions
      expect(@user.roles.first).to be_a Role
    end
    it 'should have permission_assignments of type PermissionAssignment' do
      @user.roles << Role.find_by_name("superuser") # Give roles and permissons
      @user.save # Otherwise the permissions dont work
      expect(@user.permission_assignments.first).to be_a PermissionAssignment
    end
    it 'should have permissions through permission_assignments of type Permission' do
      @user.roles << Role.find_by_name("superuser") # Give roles and permissons
      @user.save # Otherwise the permissions dont work
      expect(@user.permissions.first).to be_a Permission
    end
  end

  describe 'Test has_secure_password behavior' do
    before do
      @user = FactoryBot.create(:user, password: '12345678', password_confirmation: '12345678')
    end

    it 'should authenticate with correct password' do
      expect(@user.authenticate('12345678')).to be_truthy
    end

    it 'should not authenticate with incorrect password' do
      expect(@user.authenticate('87654321')).to be false
    end

    it 'should update with matching password and password_confirmation' do
      expect { @user.update(password: '87654321', password_confirmation: '87654321') }.to change { @user.reload; @user.authenticate('12345678') }
    end

    it 'should not update with non-matching password and password_confirmation' do
      expect { @user.update(password: '87654321', password_confirmation: '12345678') }.to_not change { @user.reload; @user.authenticate('12345678') }
    end
  end

  it 'temp_pass? should return true when user has a temp password' do
    expect(FactoryBot.build(:user, temp_pass: true).temp_pass?).to be true
  end

  it 'temp_pass? should return false when user does not have a temp password' do
    expect(FactoryBot.build(:user, temp_pass: false).temp_pass?).to be false
  end

  describe 'Permissions' do # All of these may fail if test db is not seeded.
    before do
      @admin = FactoryBot.create(:user)
      @admin.roles << Role.find_by_name("superuser")
      @default = FactoryBot.create(:user)
      @default.roles << Role.find_by_name("default")
      @seller = FactoryBot.create(:user)
      @seller.roles << Role.find_by_name("seller")
    end

    it 'superuser? should return true when user is a superuser' do
      expect(@admin).to be_superuser
    end

    it 'superuser? should return false when user is not a superuser' do
      expect(@default).to_not be_superuser
      expect(@seller).to_not be_superuser
    end

    it 'can? should return true when user has permission' do
      expect(@default.can?(:login)).to be_truthy
      expect(@seller.can?(:addStock)).to be_truthy
    end

    it 'can? should return true when user is superuser regardless of if they have permission' do
      expect(@admin.can?(:superuser)).to be_truthy
      expect(@admin.can?(:login)).to be_truthy
    end

    it 'can? should return false if user does not have permission' do
      expect(@default.can?(:addStock)).to be_falsy
    end

    it 'can? should return false if permission does not exist if not superuser' do
      expect(@default.can?(:not_a_permission)).to be_falsy
      expect(@seller.can?(:not_a_permission)).to be_falsy
    end

    it 'can? should return true if permission does not exist if superuser' do
      expect(@admin.can?(:not_a_permission)).to be_truthy
    end

    it 'can_all? should call can? with all arguments' do
      # user = double(@admin)
      expect(@admin).to receive(:can?).once.ordered.with(:perm1).and_return(true)
      expect(@admin).to receive(:can?).once.ordered.with(:perm2).and_return(true)

      @admin.can_all?([:perm1, :perm2])
    end

    it 'can_all? should not call can? with arguments after one false' do
      expect(@admin).to receive(:can?).once.ordered.with(:perm1).and_return(false)
      expect(@admin).to_not receive(:can?).with(:perm2)

      @admin.can_all?([:perm1, :perm2])
    end

    it 'can_all? should return true if can? returns true for all arguments' do
      expect(@admin).to receive(:can?).twice.and_return(true)

      expect(@admin.can_all?([:perm1, :perm2])).to be_truthy
    end

    it 'can_all? should return false if can? returns false for any argument' do
      expect(@admin).to receive(:can?).once.ordered.with(:perm1).and_return(true)
      expect(@admin).to receive(:can?).once.ordered.with(:perm2).and_return(false)

      expect(@admin.can_all?([:perm1, :perm2])).to be_falsy
    end

    it 'can_all? should return false if can? returns fales for all arguments' do
      expect(@admin).to receive(:can?).and_return(false)

      expect(@admin.can_all?([:perm1, :perm2])).to be_falsy
    end

    it 'can_any? should call can? with all arguments' do
      expect(@admin).to receive(:can?).once.ordered.with(:perm1).and_return(false)
      expect(@admin).to receive(:can?).once.ordered.with(:perm2).and_return(false)

      @admin.can_any?([:perm1, :perm2])
    end

    it 'can_any? should not call can? after one true' do
      expect(@admin).to receive(:can?).once.and_return(true)

      @admin.can_any?([:perm1, :perm2])
    end

    it 'can_any? should return true if can? returns true for all arguments' do
      expect(@admin).to receive(:can?).at_least(:once).and_return(true)

      expect(@admin.can_any?([:perm1, :perm2])).to be_truthy
    end

    it 'can_any? should return true if can? returns true for any arguments' do
      expect(@admin).to receive(:can?).once.ordered.with(:perm1).and_return(false)
      expect(@admin).to receive(:can?).once.ordered.with(:perm2).and_return(true)

      expect(@admin.can_any?([:perm1, :perm2])).to be_truthy
    end

    it 'can_any? should return false if can? returns false for all arguments' do
      expect(@admin).to receive(:can?).at_least(:once).and_return(false)

      expect(@admin.can_any?([:perm1, :perm2])).to be_falsy
    end
  end

end
