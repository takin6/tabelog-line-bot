module Api
  module Line
    class SendMessageUsecase 
      attr_reader :current_chat_unit, :restaurant_data_set, :params
      def initialize(current_chat_unit, params)
        @current_chat_unit = current_chat_unit
        @restaurant_data_set = RestaurantDataSet.find_by(cache_id: params[:restaurant_data_set_id])
        @params = params
      end

      def execute
        chat_unit = find_chat_unit
        return ServiceResult.new(false, "チャットが見つかりませんでした。") unless chat_unit

        restaurant_data_subset = RestaurantDataSubset.create!(
          chat_unit: chat_unit,
          restaurant_data_set: restaurant_data_set,
          message_type: params[:message_type],
          selected_restaurant_ids: params[:selected_restaurant_ids]
        )

        Messenger::ReplyRestaurantsMessageWorker.perform_async restaurant_data_subset.id

        return ServiceResult.new(true)
      end

      private

      def find_chat_unit
        if ["chat_room", "chat_group"].include?(current_chat_unit.chat_type) && params[:destination_type] == "user"
          return current_chat_unit.user.chat_users[0].chat_unit
        end

        return current_chat_unit
      end
    end
  end
end
