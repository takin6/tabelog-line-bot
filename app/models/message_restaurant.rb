class MessageRestaurant < ApplicationRecord
  belongs_to :message

  validates :mongo_custom_restaurants_id, presence: true
  validates :page, presence: true
end
