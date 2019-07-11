require 'mechanize'

module Scraper
  module Tabelog
    class TabelogScraper < Scraper::BaseScraper
      TABELOG_URL = "https://tabelog.com/".freeze
      attr_reader :agent, :search_history

      def initialize(search_history)
        begin
          @agent = create_agent
          @search_history = search_history
        rescue => exception
          raise exception
        end
      end

      def execute
        restaurants = []

        front_page = get_front_page

        # fill in form & get url
        restaurant_lists_page = fill_in_form(front_page)
        

        # ここで次のページがなくなるまで回す
        while restaurant_lists_page.search(".c-pagination__arrow.c-pagination__arrow--next").present?
          restaurant_lists = restaurant_lists_page.search('//*[@id="column-main"]/ul').search('li').select do |list|
            list.search(".list-rst__wrap").present?
          end

          recommendation_lists = create_recommendation_lists(restaurant_lists)
          restaurants.push(recommendation_lists.map {|restaurant| Mongo::RestaurantWrapper.new(restaurant)})

          # get next url and scrape
          next_url = restaurant_lists_page.search(".c-pagination__arrow.c-pagination__arrow--next")[0].values.select {|value| UrlUtil.valid_url?(value)}[0]
          restaurant_lists_page = agent.get(next_url)
        end

        restaurants_document = Mongo::RestaurantsWrapper.new(search_history, restaurants.flatten).to_restaurants_document

        Mongo::Restaurants.collection.bulk_write([{ insert_one: restaurants_document}])

        search_history.completed = true
        search_history.save!
        # return restaurants.flatten
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
        form.sa = search_history.station_name
        [search_history.situation, search_history.other_requests]
        form.sk = [search_history.situation, search_history.other_requests].compact.join("、") if search_history.situation.present? || search_history.other_requests.present?
        return form.submit
      end


      # meal_typeは昼食か夕食が入り、max_priceには予算上限を
      def create_recommendation_lists(restaurant_lists)
        recommendations = []

        high_rate_restaurants = restaurant_lists.map do |restaurant|
          rating = restaurant.search(".c-rating__val.c-rating__val--strong.list-rst__rating-val").text.to_f
          if rating > 3.49
            if search_history.lower_budget == 0 && search_history.upper_budget == 0
              recommendations.push(restaurant)
              next
            end
            
            # もう一度検索をした方が高速化？？
            budget_selector = search_history.dinner? ? ".cpy-dinner-budget-val" : ".cpy-lunch-budget-val"
            expected_budget_text = restaurant.search(budget_selector).text
            unless expected_budget_text == "-"
              expected_budget_list = expected_budget_text.remove(",").remove("￥").split("～").map(&:to_i)
              if search_history.lower_budget <= expected_budget_list[0] || search_history.upper_budget >= expected_budget_list[1]
                recommendations.push(restaurant)
                next
              end
            end
          end
        end

        return recommendations
      end

    end
  end
end