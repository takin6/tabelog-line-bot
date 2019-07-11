class MessageRestaurant < ApplicationRecord
  belongs_to :message

  validates :mongo_restaurants_id, presence: true
  validates :pager, presence: true
end
