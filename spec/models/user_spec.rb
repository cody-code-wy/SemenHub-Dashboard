require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'Factory' do
    it 'should have a valid factory' do
      expect(FactoryBot.build(:user)).to be_valid
    end
    it 'should have a valid factory :with_commission' do
      expect(FactoryBot.build(:user, :with_commission)).to be_valid
    end
    it 'should have a valid factory :with_animals' do
      expect(FactoryBot.build(:user, :with_animals)).to be_valid
    end
    it 'should have a vaild factory :with_purchases' do
      expect(FactoryBot.build(:user, :with_purchases)).to be_valid
    end
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
      @user = FactoryBot.build(:user, :with_animals, :with_commission, :with_purchases)
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
    it 'should have A Commission' do
      expect(@user.commission).to be_a Commission
    end
    it 'should have purchases of type Purchase' do
      expect(@user.purchases.first).to be_a Purchase
    end
    it 'should have animals of type Animal' do
      expect(@user.animals.first).to be_a Animal
    end
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

  it 'get_name returns correct format' do
    expect(FactoryBot.build(:user, first_name: 'first', last_name: 'last').get_name).to eq 'first last'
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

  describe 'Commission' do
    before do
      @user = FactoryBot.create(:user)
      @user_with_commission = FactoryBot.create(:user, :with_commission)
    end

    it 'should have default 10% commission if none is set' do
      expect(@user.commission).to be_new_record
      expect(@user.commission.commission_percent).to be 10.0
    end

    it 'should have set commission if set' do
      expect(@user_with_commission.commission).to_not be_new_record
    end

    it 'should update properly from default commission' do
      expect{@user.commission.update( commission_percent: 15.0 )}.to change { User.find(@user.id).commission.commission_percent }
    end

    it 'should update properly from set commission' do
      expect{@user_with_commission.commission.update( commission_percent: 5.0 )}.to change { User.find(@user_with_commission.id).commission.commission_percent }
    end

  end

  describe 'password_changed?' do
    before do
      @user = FactoryBot.create(:user)
    end
    it 'should return false without changing the password' do
      @user = User.find_by_email(@user.email)
      expect(@user.password_changed?).to be_falsy
    end
    it 'should be true for a new user without password_digest' do
      expect(User.new.password_changed?).to be_truthy
    end
    it 'should be true if the password has been changed' do
      @user.password = 'new_password'
      expect(@user.password_changed?).to be_truthy
    end
  end

  describe 'Redis User Store' do
    before do
      @user = FactoryBot.create(:user)
      @settings_hash = {'test_data' => true, 'current_cart' => 'test'}
    end
    feature 'set_user_redis_store' do
      it 'should set the USER-#{id} on redis to json of settings_hash' do
        @user.send(:set_user_redis_store, @settings_hash)
        expect($redis.get("USER-#{@user.id}")).to eq @settings_hash.to_json
      end
      it 'should set expire on USER-#{id} on redis' do
        @user.send(:set_user_redis_store, @settings_hash)
        expect($redis.ttl("USER-#{@user.id}")).to be >= 0
      end
    end
    feature 'clear_user_redis_store' do
      it 'should delete USER-#{id} on redis' do
        $redis.set("USER-#{@user.id}", @settings_hash.to_json)
        $redis.expire("USER-#{@user.id}", $redis_timeout)
        expect{
          @user.send(:clear_user_redis_store)
        }.to change{
          $redis.get("USER-#{@user.id}")
        }.to(nil)
      end
    end
    feature 'get_user_redis_store' do
      describe 'JSON in redis' do
        it 'should return object coded from JSON' do
          $redis.set("USER-#{@user.id}", @settings_hash.to_json)
          $redis.expire("USER-#{@user.id}", $redis_timeout)
          expect(@user.send(:get_user_redis_store)).to eq @settings_hash
        end
      end
      describe 'Nil/invalid JSON in redis' do
        it 'should return empty hash' do
          $redis.set("USER-#{@user.id}", "This is not JSON")
          expect(@user.send(:get_user_redis_store)).to eq({})
          $redis.del("USER-#{@user.id}") #This will cause get to return Nil
          expect(@user.send(:get_user_redis_store)).to eq({})
        end
      end
    end
  end

  describe 'Cart' do
    before do
      @user = FactoryBot.create(:user)
      @settings_hash = {'test_data' => true, 'current_cart' => 'test'}
    end
    feature 'cart' do
      it 'should return value of "current_cart" from user store on redis if set' do
        $redis.set("USER-#{@user.id}", @settings_hash.to_json)
        $redis.expire("USER-#{@user.id}", $redis_timeout)
        expect(@user.cart).to eq 'test'
      end
      it 'should return value of 0 if "current_cart" from user store on redis is not set' do
        $redis.del("USER-#{@user.id}")
        expect(@user.cart).to eq 0
      end
      it 'should call get_user_redis_store' do
        expect(@user).to receive(:get_user_redis_store) { @settings_hash }
        @user.cart
      end
    end
    feature 'cart=' do
      it 'should set "current_cart" on user store on redis' do
        @user.cart = 2
        expect(JSON.parse($redis.get("USER-#{@user.id}"))['current_cart']).to eq 2
      end
      it 'should not change other keys on user store on redis' do
        $redis.set("USER-#{@user.id}", @settings_hash.to_json)
        $redis.expire("USER-#{@user.id}", $redis_timeout)
        @user.cart = 2
        expect(JSON.parse($redis.get("USER-#{@user.id}"))['test_data']).to be_truthy
      end
      it 'should call get_user_redis_store' do
        expect(@user).to receive(:get_user_redis_store) { @settings_hash }
        @user.cart = 2
      end
      it 'should call set_user_redis_store with hash' do
        expect(@user).to receive(:set_user_redis_store)
        @user.cart = 2
      end
    end
  end
end
