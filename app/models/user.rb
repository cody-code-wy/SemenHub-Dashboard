class User < ApplicationRecord
  belongs_to :billing_address, class_name: 'Address'
  belongs_to :mailing_address, class_name: 'Address'
  belongs_to :payee_address, class_name: 'Address', required: false

  has_many :purchases
  has_many :animals, foreign_key: 'owner_id'
  has_many :skus, foreign_key: 'seller_id'
  has_many :role_assignments, dependent: :destroy
  has_many :roles, through: :role_assignments
  has_many :permission_assignments, through: :roles
  has_many :permissions, through: :permission_assignments

  has_one :commission, class_name: 'Commission' # class_name required due to rails bug

  validates :email, presence: true, email: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 8}, confirmation: true, if: :password_changed?
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_primary, presence: true

  has_secure_password confirmation: true

  def get_name
    "#{first_name} #{last_name}"
  end

  def commission
    super || Commission.new(user: self, commission_percent: 10) # Default value
  end

  def superuser?
    self.permissions.any? do |perm| perm.name.underscore.to_sym == :superuser end
  end

  def can? permission = nil
    return true if superuser? or permission.nil?
    self.permissions.any? do |perm| perm.name.underscore.to_sym == permission.to_s.underscore.to_sym end
  end

  def can_all? perms
    perms.reduce(true) do |allow, perm| allow and self.can? perm end
  end

  def can_any? perms
    perms.any? do |perm| self.can? perm end
  end

  def temp_pass?
    return temp_pass
  end

  def password_changed?
    !password.blank? or password_digest.blank?
  end

  def cart= cart_name
    user_store = get_user_redis_store
    user_store["current_cart"] = cart_name
    set_user_redis_store user_store
  end

  def cart
    begin
      return get_user_redis_store["current_cart"]
    rescue
      return 0
    end
  end

  private

  def set_user_redis_store settings_hash
    $redis.set "USER-#{id}", settings_hash.to_json
    $redis.expire "USER-#{id}", $redis_timeout
  end

  def clear_user_redis_store
    $redis.del "USER-#{id}"
  end

  def get_user_redis_store
    out = {}
    begin
      out =JSON.parse($redis.get("USER-#{id}"))
    rescue TypeError
      return out
    end
    return out
  end
end
