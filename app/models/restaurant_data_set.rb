class RestaurantDataSet < ApplicationRecord
  before_create :generate_cache_id

  belongs_to :user

  has_many :restaurant_data_subsets

  validates :mongo_custom_restaurants_id, presence: true
  validates :selected_restaurant_ids, presence: true
  validates :title, presence: true

  def search_history
    SearchHistory.find_by(cache_id: self.mongo_custom_restaurants_id)
  end

  def to_h
    search_history_cache_id = Mongo::CustomRestaurants.find_by(cache_id: self.mongo_custom_restaurants_id).cache_id
    search_history = SearchHistory.find_by(cache_id: search_history_cache_id)
    return {
      title: self.title,
      station_name: search_history.station.name,
      meal_type: search_history.meal_type,
      genre: master_genres + custom_genres.split(),
      budget: search_history.lower_budget.format + " ~ " + search_history.upper_budget.format
    }
  end

  protected

  def generate_cache_id
    self.cache_id = "#{SecureRandom.hex(8)}-#{Time.zone.now.to_i}"
  end
end
