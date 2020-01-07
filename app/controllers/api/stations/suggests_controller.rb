module Api
  module Stations
    class SuggestsController < ActionController::API
      def index
        query = params[:query]

        render json: {} unless query
        result = []

        station_response = Station.search(params[:query])
        suggest_stations = station_response.to_a[0..4].map do |station|
          { id: station["_source"][:id], name: station["_source"][:name], type: station["_source"][:type]}
        end
        result.append(suggest_stations)

        area_response = Area.search(params[:query])
        suggest_areas = area_response.to_a[0..4].map do |area|
          { id: area["_source"][:id], name: area["_source"][:name], type: area["_source"][:type] }
        end
        result.append(suggest_areas)

        exact_match = suggest_stations.select {|station| station[:name].include?(query) }
        # exact_matchがあったら、areaも上位1件のみ表示。
        render json: exact_match.present? ? [exact_match, suggest_areas[0]].flatten : result.flatten
      end

      private

      def suggests_params
        params.permit(:query)
      end
    end
  end
end
