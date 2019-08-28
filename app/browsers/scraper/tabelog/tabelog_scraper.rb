require 'mechanize'

module Scraper
  module Tabelog
    class TabelogScraper < Scraper::BaseScraper
      TABELOG_URL = "https://tabelog.com/".freeze
      MINIMUM_STANDARD_RANK = 3.45.freeze
      attr_reader :agent, :station

      def initialize(station)
        begin
          @agent = create_agent
          @station = station
        rescue => exception
          raise exception
        end
      end

      def execute
        restaurants = []

        front_page = get_front_page

        # fill in form & get url
        restaurant_lists_page = fill_in_form(front_page)

        # go to rank page
        rank_page = get_rank_page(restaurant_lists_page)
        loop_count = 1

        # ここで次のページがなくなるまで回す
        while rank_page.search(".c-pagination__arrow.c-pagination__arrow--next").present?
          puts "#{loop_count} start"

          restaurant_lists = rank_page.search('//*[@id="column-main"]/ul').search('li').select do |list|
            list.search(".list-rst__wrap").present?
          end

          recommendation_lists = create_recommendation_lists(restaurant_lists)
          restaurants.push(recommendation_lists.map {|restaurant| Mongo::RestaurantWrapper.new(restaurant)})

          puts "#{loop_count} finished"
          loop_count += 1

          break unless recommendation_lists.count == restaurant_lists.count
          # get next url and scrape
          next_url = rank_page.search(".c-pagination__arrow.c-pagination__arrow--next")[0].values.select {|value| UrlUtil.valid_url?(value)}[0]
          rank_page = agent.get(next_url)
        end

        agent.shutdown

        restaurants_document = Mongo::RestaurantsWrapper.new(station, restaurants.flatten).to_restaurants_document

        Mongo::Restaurants.collection.bulk_write([{ insert_one: restaurants_document}])

        station.scraping_completed = true
        station.save!
      end

      private
      def create_agent
        agent = Mechanize.new
        agent.user_agent_alias = 'Mac Mozilla'
        return agent
      end

      def get_front_page
        return agent.get(TABELOG_URL)
      end

      # queryにはgenre（中華、焼肉、店名、個室などが入る）
      def fill_in_form(front_page)
        form = front_page.form('FrmSrchFreeWord')
        form.sa = station.name

        return form.submit
      end

      def get_rank_page(front_page)
        rank_page_tab = front_page.search(".navi-rstlst__label.navi-rstlst__label--rank")
        rank_page_link = rank_page_tab[0].values[1]

        return agent.get(rank_page_link)
      end

      # meal_typeは昼食か夕食が入り、max_priceには予算上限を
      def create_recommendation_lists(restaurant_lists)
        recommendations = []

        high_rate_restaurants = restaurant_lists.map do |restaurant|
          rating = restaurant.search(".c-rating__val.c-rating__val--strong.list-rst__rating-val").text.to_f
          recommendations.push(restaurant) if rating >= MINIMUM_STANDARD_RANK
        end

        return recommendations
      end

    end
  end
end