namespace :scraping do
  namespace :tabelog do
    desc "crawling tabelog restaurant"
    task :crawl => :environment do
      search_history = SearchHistory.first
      tabelog_scraper = Scraper::Tabelog::TabelogScraper.new(search_history)
      restaurants = tabelog_scraper.execute
      p restaurants
    end
  end
end