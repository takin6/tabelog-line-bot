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

  def is_outdated_cache_id
    # 暫定：24時間より以前のsearch_historyだったら、アクション起こさない
    return true if created_at > Time.zone.now.ago(24.hours.ago)

    false
  end

  def self.create_from_params(chat_unit_id, params)
    search_history = SearchHistory.create!(
      chat_unit_id: chat_unit_id,
      lower_budget_cents: params[:budget][:lower].to_i,
      upper_budget_cents: params[:budget][:upper].to_i,
      meal_type: params[:meal_type],
      custom_meal_genres: params[:genre][:custom_input],
      master_genres: params[:genre][:master_genres].present? ? params[:genre][:master_genres].to_json : ["指定なし"]
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

    result += "場所: #{self.station.name}\n食事タイプ: #{self.lunch? ? "ランチ" : "ディナー"}\n予算: #{self.lower_budget.zero? ? "指定なし" : self.lower_budget.format} ~ #{self.upper_budget.zero? ? "指定なし" : self.upper_budget.format}\nジャンル: #{self.genre_to_str}"

    return result
  end

  def genre_to_str
    result = []
    if custom_meal_genres
      custom_meal_genres.split("、").map do |custom_genre|
        result.push(custom_genre)
      end
    end

    JSON.parse(master_genres).map do |master_genre|
      result.push(master_genre)
    end

    return result.join("、")
  end

  def to_json
    # 暫定：t - 6時間以内に検索アクションがあった時のみ、キャッシュ情報を表示
    if self.created_at > Time.zone.now.ago(6.hours)
      return {
        location: self.station.name,
        meal_type: self.meal_type,
        lower_budget: self.lower_budget_cents,
        upper_budget: self.upper_budget_cents,
        custom_meal_genre: self.custom_meal_genres.nil? ? "指定なし" : self.custom_meal_genres,
        master_genres: unless self.master_genres.include?("指定なし")
                         master_genres_to_a = JSON.parse(self.master_genres)
                         master_genres_to_a.map do |master_genre|
                           {
                             id: MasterRestaurantGenre.find_by(parent_genre: master_genre).id,
                             parent_genre: master_genre
                           }
                          end
                       end
      }
    end
  end

  protected

  def generate_cache_id
    self.cache_id = "#{SecureRandom.hex(8)}-#{Time.zone.now.to_i}"
  end

end
