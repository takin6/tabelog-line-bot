module Api
  module Stations
    class SuggestsController < ActionController::API
      def index
        query = params[:query]

        render json: {} unless query

        response = Station.search(query)
        result = response.to_a[0..4].map do |result_station|
          { id: result_station["_source"][:id], name: result_station["_source"][:name] }
        end
        exact_match = result.select {|station| station[:name].include?(query) }
        # 上位５件のみ表示
        render json: { stations: exact_match.present? ? exact_match : result }
      end

      private

      def suggests_params
        params.permit(:query)
      end
    end
  end
end
