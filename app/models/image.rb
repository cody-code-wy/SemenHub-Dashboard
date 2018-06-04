class Image < ApplicationRecord
  belongs_to :animal

  validates :url_format, presence: true
end
