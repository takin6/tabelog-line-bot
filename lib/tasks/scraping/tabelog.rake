namespace :scraping do
  namespace :tabelog do
    desc "crawling tabelog restaurant"
    task :crawl => :environment do
      search_history = SearchHistory.create!(
        user_id: User.last.id,
        lower_budget: 0,
        upper_budget: 0,
        meal_type: "lunch",
      )

      station = Station.find_by(name: "赤坂見附")
      StationSearchHistory.create!(station: station, search_history: search_history)

      tabelog_scraper = Scraper::Tabelog::TabelogScraper.new(search_history)
      restaurants = tabelog_scraper.execute
      p restaurants
    end
  end
end