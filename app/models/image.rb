class Image < ApplicationRecord
  belongs_to :animal

  validates :url_format, presence: true
  validate :s3_object_format

  def url(width=250)
    url_format % [width]
  end

  private

  def s3_object_format
    return unless s3_object
    errors.add(:s3_object, "S3 Object must be a String") unless s3_object.match("^#{animal.id}:.+")
  end
end
