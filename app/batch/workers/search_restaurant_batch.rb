module Workers
  class SearchRestaurantBatch
    def execute(user_id)
      user = User.find(user_id)
      search_history = user.search_histories.last

      Scraper::Tabelog::TabelogScraper.new(search_history).execute
    end
  end
end