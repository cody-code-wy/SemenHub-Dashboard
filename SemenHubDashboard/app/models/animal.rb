class Animal < ApplicationRecord
  belongs_to :breed
  belongs_to :owner, class_name: 'User'
end
