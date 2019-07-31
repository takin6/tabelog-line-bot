class MessageButton < ApplicationRecord
  belongs_to :message

  validates :actions, presence: true
  validates :thumbnail_image_url, presence: true
end
