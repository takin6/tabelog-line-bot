module Mongo
  class Restaurants
    include Mongoid::Document
    include Mongoid::Timestamps

    field :station_id
    field :max_page
    field :restaurants, type: Array
  end
end

