module Mongo
  class RestaurantsWrapper
    attr_reader :search_history, :restaurant_wrappers

    def initialize(search_history, restaurant_wrappers)
      @search_history = search_history
      @restaurant_wrappers = restaurant_wrappers
    end

    def to_restaurants_document
      # ここ何でまとめよっかなー
      # TODO: other_reqeustsの一覧リストってスクレイピングから取ってこれない？
      # search_historiesをリスト見たいのにして、誰が検索したのかわかったら面白いかも？
      return {
        station_id: search_history.station_id,
        other_requests: search_history.other_requests,
        restaurants: restaurant_wrappers.map do |restaurant|
          restaurant.to_restaurant_document(search_history.meal_type)
        end
      }
    end

  end
end