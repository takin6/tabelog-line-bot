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

    def self.next_page(current_page)
      return nil if current_page + 1 > self.max_page

      return current_page + 1
    end

    def self.create_index(apparent_page)
      page = apparent_page - 1
      if page == 0
        from = 0
        to = 8
      else
        from = page * 9
        to = apparent_page == max_page ? self.restaurants.length : page * 9 + 8
      end

      return from, to
    end
  end
end
