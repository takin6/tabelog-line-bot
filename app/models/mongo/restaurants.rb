module Mongo
  class Restaurants
    include Mongoid::Document
    include Mongoid::Timestamps

    field :station_id
    field :other_requests
    field :restaurants, type: Array

    def sort_restaurants_by_rating
      return self.restaurants.sort_by do |restaurant|
        restaurant[:rating]
      end.reverse
    end

    def self.create_index(apparent_pager)
      pager = apparent_pager - 1
      if pager == 0
        from = 0
        to = 8
      else
        from = pager * 9,
        to = pager * 9 + 8
      end

      return from, to
    end
  end
end
