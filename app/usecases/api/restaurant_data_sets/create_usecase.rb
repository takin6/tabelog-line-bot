module Api
  module RestaurantDataSets
    class CreateUsecase
      attr_reader :params, :chat_unit
      def initialize(params, chat_unit)
        @params = params
        @chat_unit = chat_unit
      end

      def execute
        user = chat_unit.user

        restaurant_data_set = RestaurantDataSet.create!(
          mongo_custom_restaurants_id: params[:mongo_custom_restaurants_id],
          selected_restaurant_ids: params[:selected_restaurant_ids],
          user_id: user.id
        )

        return restaurant_data_set.cache_id
      end
    end
  end
end
