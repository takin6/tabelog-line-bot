class MessagePostback < ApplicationRecord
  belongs_to :message

  validates :mongo_restaurants_id, presence: true
  validates :page, presence: true
end
