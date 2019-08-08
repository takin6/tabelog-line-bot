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

  def self.create_from_params(chat_unit_id, params)
    search_history = SearchHistory.create!(
      chat_unit_id: chat_unit_id,
      lower_budget: params[:budget][:lower].to_i,
      upper_budget: params[:budget][:upper].to_i,
      meal_type: params[:meal_type],
      meal_genre: params[:genre] == "なし" ? nil : params[:genre],
      # situation: params[:situation],
      # other_requests: params[:other_requests]
    )

    station = Station.find_by(name: params[:location])
    StationSearchHistory.create!(station: station, search_history: search_history)

    search_history
  end

  protected

  def generate_cache_id
    self.cache_id = "#{SecureRandom.hex(8)}-#{Time.zone.now.to_i}"
  end

end
