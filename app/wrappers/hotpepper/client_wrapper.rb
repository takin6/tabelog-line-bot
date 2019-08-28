require 'hotpepper/client'

module Hotpepper
  class ClientWrapper
    attr_reader :client, :logger
    def initialize(expedia_args = {}, logger = Rails.logger)
      @client = Hotpepper::Client.new(expedia_args[:ip], expedia_args[:user_agent], expedia_args[:test_header])
      @logger = logger
    end

    def get_small_areas(middle_area_code)
      client.get_small_areas({middle_area: middle_area_code })
    end

    def get_middle_areas(large_area_code)
      client.get_middle_areas({large_area: large_area_code})
    end

    def search_restaurants_by_region(region_code)
      client.search_restaurants({small_area: region_code, count: 100})
    end
  end
end
