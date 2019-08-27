require 'hotpepper/client'

module Hotpepper
  class ClientWrapper
    attr_reader :client, :logger
    def initialize(expedia_args = {}, logger = Rails.logger)
      @client = Hotpepper::Client.new(expedia_args[:ip], expedia_args[:user_agent], expedia_args[:test_header])
      @logger = logger
    end

    def get_middle_areas
      result = client.get_middle_areas

      File.open(Rails.root.join("spec", "fixtures", "middle_areas.json"), "w") do |file|
        file << JSON.pretty_generate(result.values)
      end

      return result
    end

    def search_restaurants(station_name)
      client.search_restaurants({station_name: station_name})
    end
  end
end
