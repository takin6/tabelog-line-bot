require 'mechanize'

module Scraper
  module Tabelog
    class TabelogPictureScraper < Scraper::BaseScraper
      MINIMUM_STANDARD_RANK = 3.45.freeze
      attr_reader :agent, :restaurant_url

      def initialize(restaurant_url)
        begin
          @agent = create_agent
          @restaurant_url = restaurant_url
        rescue => exception
          raise exception
        end
      end

      def execute
        page = get_front_page
        photo_elements = page.search(".js-imagebox-trigger")

        pictures = photo_elements.map do |photo_element|
          img_element = photo_element.search("img")[0]
          url = img_element.attributes["src"].value
          url.sub(/150x150_square_/, '')
        end

        return pictures
      end

      private
      def create_agent
        agent = Mechanize.new
        agent.user_agent_alias = 'Mac Mozilla'
        return agent
      end

      def get_front_page
        return agent.get(restaurant_url)
      end

    end
  end
end