class User < ApplicationRecord

  has_secure_password confirmation: true

  belongs_to :billing_address, class_name: 'Address'
  belongs_to :mailing_address, class_name: 'Address'
  belongs_to :payee_address, class_name: 'Address', required: false

  has_one :commission, class_name: 'Commission' # class_name required due to rails bug

  has_many :purchases
  has_many :animals, foreign_key: 'owner_id'
  has_many :skus, foreign_key: 'seller_id'
  has_many :role_assignments, dependent: :destroy
  has_many :roles, through: :role_assignments
  has_many :permission_assignments, through: :roles
  has_many :permissions, through: :permission_assignments

  validates :email, presence: true, email: true

  validates :password, length: {minimum: 8}

  validates_presence_of :first_name, :last_name, :phone_primary

  validates_uniqueness_of :email

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
end
