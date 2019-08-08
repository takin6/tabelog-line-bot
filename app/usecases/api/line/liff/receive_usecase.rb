module Api
  module Line
    module Liff
      class ReceiveUsecase 
        attr_reader :chat_unit, :params
        def initialize(chat_unit, params)
          @chat_unit = chat_unit
          @params = params
        end

        def execute
          # recieve
          search_history = SearchHistory.create_from_params(chat_unit.id, params)

          if Mongo::Restaurants.where(station_id: search_history.station_id).count == 0
            return ServiceResult.new(false, "レストランが一件も検索されませんでした")
          else
            mongo_restaurants = Mongo::Restaurants.find_by(station_id: search_history.station_id)
            Mongo::CustomRestaurants.create_document!(search_history, mongo_restaurants)

            if Mongo::CustomRestaurants.where(cache_id: search_history.cache_id ).first.restaurants.length == 0
              return ServiceResult.new(false, "レストランが一件も検索されませんでした。別の検索条件をお試してください。")
            end
          end

          search_history.completed = true
          search_history.save!

          Messenger::ReplyRestaurantsFlexMessageWorker.perform_async search_history.cache_id

          return ServiceResult.new(true)
        end
      end
    end
  end
end
