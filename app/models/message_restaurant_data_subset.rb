class MessageRestaurantDataSubset < ApplicationRecord
  belongs_to :message

  validates :restaurant_data_subset_id, presence: true
end
