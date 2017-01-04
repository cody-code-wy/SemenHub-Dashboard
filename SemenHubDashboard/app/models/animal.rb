class Animal < ApplicationRecord
  has_many :registrations
  belongs_to :owner, class_name: 'User'
  belongs_to :breed

  validates_presence_of :name

  def get_drop_down_name
    "#{name} - #{owner.first_name} #{owner.last_name}"
  end

  def get_registrations
    ret = ''
    registrations.each do |r|
      ret += r.registration
      ret += ', ' unless r.equal? registrations.last
    end
    ret
  end

end
