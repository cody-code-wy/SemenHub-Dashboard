class Animal < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  belongs_to :breed
  belongs_to :sire, class_name: 'Animal', optional: true
  belongs_to :dam, class_name: 'Animal', optional: true


  has_many :registrations
  has_many :skus

  validates :name, presence: true
  validates :is_male, inclusion: [true, false]

  validate :sire_must_be_male, :dam_must_be_female

  def get_drop_down_name
    "#{name} - #{owner.first_name} #{owner.last_name}"
  end

  def children #acts as has_many association with 2 foreign keys
    Animal.where('sire_id = ? or dam_id = ?', self.id, self.id)
  end

  private

  def sire_must_be_male
    return unless sire.present?
    errors.add(:sire, "sire must be male") unless sire.is_male
  end

  def dam_must_be_female
    return unless dam.present?
    errors.add(:dam, "dam must be female") if dam.is_male
  end
end
