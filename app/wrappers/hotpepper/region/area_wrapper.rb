module Hotpepper
  module Region
    class AreaWrapper
      attr_reader :client_wrapper, :area_name, :area_code
      def initialize(client_wrapper, area_name, area_code)
        @client_wrapper = client_wrapper
        @area_name = area_name
        @area_code = area_code
      end

      def to_h
        return {
          name: area_name,
          code: area_code,
          regions: get_regions.map do |region|
            {
              name: region["name"],
              code: region["code"]
            }
          end
        }
      end

      def get_regions
        client_wrapper.get_small_areas(area_code).values["results"]["small_area"]
      end
    end
  end
end
