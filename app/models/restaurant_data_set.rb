class RestaurantDataSet < ApplicationRecord
  before_create :generate_cache_id

  belongs_to :user

  validates :mongo_custom_restaurants_id, presence: true
  validates :selected_restaurant_ids, presence: true
  validates :title, presence: true

  def search_history
    SearchHistory.find_by(cache_id: self.mongo_custom_restaurants_id)
  end

  protected

  def generate_cache_id
    self.cache_id = "#{SecureRandom.hex(8)}-#{Time.zone.now.to_i}"
  end
end
