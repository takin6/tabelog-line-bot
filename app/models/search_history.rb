class SearchHistory < ApplicationRecord
  before_create :generate_cache_id

  belongs_to :chat_unit
  has_one :station_search_history, dependent: :destroy
  has_one :station, through: :station_search_history

  delegate :id, :name, to: :station, prefix: :station

  enum meal_type: %i[lunch dinner]

  validates :lower_budget, null: false
  validates :upper_budget, null: false
  validates :meal_type, inclusion: { in: SearchHistory.meal_types.keys }

  monetize :lower_budget_cents, allow_nil: true
  monetize :upper_budget_cents, allow_nil: true

  def self.create_from_params(chat_unit_id, params)
    search_history = SearchHistory.create!(
      chat_unit_id: chat_unit_id,
      lower_budget_cents: params[:budget][:lower].to_i,
      upper_budget_cents: params[:budget][:upper].to_i,
      meal_type: params[:meal_type],
      meal_genre: params[:genre] == "なし" ? nil : params[:genre],
      # situation: params[:situation],
      # other_requests: params[:other_requests]
    )

    station = Station.find_by(name: params[:location])
    StationSearchHistory.create!(station: station, search_history: search_history)

    search_history
  end

  def search_result_message(page)
    mongo_custom_restaurants = Mongo::CustomRestaurants.find_by(cache_id: cache_id)
    from, to = mongo_custom_restaurants.create_apparent_index(page)

    result = "📍検索結果 #{from}"
    result += " ~ #{to}" if from != to
    result += " / #{mongo_custom_restaurants.restaurants.length}\n\n"

    result += "場所: #{self.station.name}\n食事タイプ: #{self.lunch? ? "ランチ" : "ディナー"}\n予算: #{self.lower_budget.format} ~ #{self.upper_budget.format}\nジャンル: #{self.meal_genre}"

    return result
  end

  protected

  def generate_cache_id
    self.cache_id = "#{SecureRandom.hex(8)}-#{Time.zone.now.to_i}"
  end

end
