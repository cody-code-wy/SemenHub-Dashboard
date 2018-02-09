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
end
