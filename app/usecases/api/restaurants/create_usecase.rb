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

        search_history.completed = true
        search_history.save!

        return mongo_custom_restaurants
      end
    end
  end
end