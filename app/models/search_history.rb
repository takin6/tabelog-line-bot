class SearchHistory < ApplicationRecord
  belongs_to :user
  has_one :station_search_history, dependent: :destroy

  has_one :station, through: :station_search_history

  delegate :id, :name, to: :station, prefix: :station

  enum meal_type: %i[lunch dinner]

  validates :lower_budget, null: false
  validates :upper_budget, null: false
  validates :meal_type, inclusion: { in: SearchHistory.meal_types.keys }

  def self.create_from_message(user_id, message)
    location, meal_type, budget, meal_genre, situation, other_requests = message.split("\n")
    lower_budget, upper_budget = budget.split("~").map(&:to_i)

    # meal_kindとかは、機械学習でどうにかできないの？よくわからないけど
    search_history = SearchHistory.create!(
      user_id: user_id,
      lower_budget: lower_budget || 0,
      upper_budget: upper_budget || 0,
      meal_type: meal_type == "ディナー" ? "dinner" : "lunch",
      meal_genre: meal_genre == "なし" ? nil : meal_genre,
      situation: situation == "なし" ? nil : situation,
      other_requests: other_requests == "なし" ? nil : other_requests
    )

    station = Station.find_by(name: location)
    StationSearchHistory.create!(station: station, search_history: search_history)
  end
end
