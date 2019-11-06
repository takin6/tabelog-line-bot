module Mongo
  class Restaurants
    include Mongoid::Document
    include Mongoid::Timestamps

    field :station_id
    field :max_page
    field :meal_genres
    field :restaurants, type: Array

    def station_name
      Station.find(self.station_id).name
    end
  end
end
