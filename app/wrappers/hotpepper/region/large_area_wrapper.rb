module Hotpepper
  module Region
    class LargeAreaWrapper
      attr_reader :large_area_name, :large_area_code, :client_wrapper
      def initialize(large_area_name, large_area_code)
        @large_area_name = large_area_name
        @large_area_code = large_area_code
        @client_wrapper = Hotpepper::ClientWrapper.new
      end

      def large_area_to_h
        return {
          large_area_name: large_area_name,
          large_area_code: large_area_code,
          areas: get_areas.map do |area|
            middle_area_wrapper = AreaWrapper.new(client_wrapper, area["name"], area["code"])
            middle_area_wrapper.to_h
          end
        }
      end

      def get_areas
        client_wrapper.get_middle_areas("Z011").values["results"]["middle_area"]
      end
    end
  end
end
