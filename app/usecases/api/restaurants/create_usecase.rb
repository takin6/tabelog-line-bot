module Api
  module Restaurants
    class CreateUsecase
      attr_reader :params
      def initialize(params)
        @params = params
      end

      def execute
        # recieve
        search_history = SearchHistory.create_from_params(params)

        result = search_history.station.present? ? create_documents_from_station(search_history) : create_documents_from_area(search_history)
        return result if result.is_a?(ServiceResult)

        search_history.completed = true
        search_history.save!

        return result
      end

      def create_documents_from_station(search_history)
        if Mongo::Restaurants.where(station_id: search_history.station_id).count == 0
          return ServiceResult.new(false, "レストランが一件も検索されませんでした")
        else
          mongo_restaurants = Mongo::Restaurants.find_by(station_id: search_history.station_id)
          Mongo::CustomRestaurants.create_document!(search_history, mongo_restaurants)

          mongo_custom_restaurants = Mongo::CustomRestaurants.where(cache_id: search_history.cache_id ).first

          if mongo_custom_restaurants.restaurants.length == 0
            return ServiceResult.new(false, "レストランが一件も検索されませんでした。別の検索条件をお試してください。")
          end
        end

        return mongo_custom_restaurants
      end

      def create_documents_from_area(search_history)
        mongo_restaurants = []

        stations = search_history.area.stations
        stations.each do |station|
          mongo_restaurants.append(Mongo::Restaurants.find_by(station_id: station.id))
        end

        Mongo::CustomRestaurants.create_document!(search_history, mongo_restaurants)

        mongo_custom_restaurants = Mongo::CustomRestaurants.where(cache_id: search_history.cache_id ).first

        if mongo_custom_restaurants.restaurants.length == 0
          return ServiceResult.new(false, "レストランが一件も検索されませんでした。別の検索条件をお試してください。")
        end

        return mongo_custom_restaurants
      end
    end
  end
end