class RestaurantDataSubset < ApplicationRecord
  belongs_to :restaurant_data_set
  belongs_to :chat_unit

  has_many :message_line_share_buttons

  validates :selected_restaurant_ids, presence: true
  enum message_type: %i[text carousel]

  def meal_type
    mongo_custom_restaurants = Mongo::CustomRestaurants.find_by(cache_id: self.restaurant_data_set.mongo_custom_restaurants_id)
    return mongo_custom_restaurants.meal_type
  end

  def selected_restaurants
    mongo_custom_restaurants = Mongo::CustomRestaurants.find_by(cache_id: self.restaurant_data_set.mongo_custom_restaurants_id)
    return mongo_custom_restaurants.selected_restaurants(self.selected_restaurant_ids)
  end

  def message_carousel(page)
    restaurant_data_set = self.restaurant_data_set
    search_history = restaurant_data_set.search_history
    mongo_custom_restaurants = Mongo::CustomRestaurants.find_by(cache_id: search_history.cache_id)
    from, to = self.create_apparent_index(page)

    result = "📍検索結果 #{from}"
    result += " ~ #{to}" if from != to
    result += " / #{self.selected_restaurant_ids.length}\n\n"

    result += "場所: #{search_history.location.name}\n食事タイプ: #{search_history.lunch? ? "ランチ" : "ディナー"}\n予算: #{search_history.lower_budget.zero? ? "指定なし" : search_history.lower_budget.format} ~ #{search_history.upper_budget.zero? ? "指定なし" : search_history.upper_budget.format}\nジャンル: #{search_history.genre_to_str}"

    return result
  end

  def message_text
    restaurant_data_set = self.restaurant_data_set
    search_history = restaurant_data_set.search_history

    result = "📍 #{self.selected_restaurant_ids.length}件の候補\n"
    result += "場所: #{search_history.location.name}\n食事タイプ: #{search_history.lunch? ? "ランチ" : "ディナー"}\n予算: #{search_history.lower_budget.zero? ? "指定なし" : search_history.lower_budget.format} ~ #{search_history.upper_budget.zero? ? "指定なし" : search_history.upper_budget.format}\nジャンル: #{search_history.genre_to_str} \n\n"

    self.selected_restaurants.each.with_index(1) do |restaurant, i|
      result += "#{i}. #{restaurant["name"]}\n"
      result += "評価: #{restaurant["rating"]} ジャンル: #{restaurant["area_genre"]}\n"
      result += "#{restaurant["redirect_url"]}\n\n"
    end

    return result
  end

  # display index for user
  def create_apparent_index(apparent_page)
    page = apparent_page - 1
    if page == 0
      from = 1
      to = apparent_page == self.max_page ? self.selected_restaurant_ids.length : 9
    else
      from = page * 9 + 1
      to = apparent_page == self.max_page ? self.selected_restaurant_ids.length : apparent_page * 9
    end

    return from, to
  end

  # for selecting mongo documents
  def create_mongo_index(apparent_page)
    page = apparent_page - 1
    if page == 0
      from = 0
      to = apparent_page == self.max_page ? self.selected_restaurant_ids.length-1 : 8
    else
      from = page * 9
      to = apparent_page == self.max_page ? self.selected_restaurant_ids.length-1 : apparent_page * 9 -1
    end

    return from, to
  end

  def next_page(current_page)
    return nil if current_page + 1 > self.max_page

    return current_page + 1
  end

  def max_page
    (self.selected_restaurant_ids.count / 9.0).ceil
  end
end
