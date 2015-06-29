class Item < ActiveRecord::Base
  belongs_to :user

  # paperclip for the bucket list items
  has_attached_file :image, styles: { medium: "300x300>", thumb: "150x150#"}
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
