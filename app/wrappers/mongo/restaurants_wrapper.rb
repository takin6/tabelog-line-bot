module Mongo
  class RestaurantsWrapper
    attr_reader :station, :restaurant_wrappers

    def initialize(station, restaurant_wrappers)
      @station = station
      @restaurant_wrappers = restaurant_wrappers
    end

    def to_restaurants_document
      # search_historiesをリスト見たいのにして、誰が検索したのかわかったら面白いかも？
      return {
        station_id: station.id,
        # station_name: station.name,
        max_page: max_page,
        restaurants: restaurant_wrappers.map do |restaurant|
          restaurant.to_restaurant_document
        end
      }
    end

    def to_restaurant_document_from_csv
      return {
        station_id: station.id,
        # station_name: station.name,
        max_page: max_page,
        restaurants: restaurant_wrappers.map do |restaurant|
          restaurant.to_restaurant_document_from_csv
        end
      }
    end

    def max_page
      return (restaurant_wrappers.count / 8.0).ceil
    end

  end
end