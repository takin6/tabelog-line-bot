namespace :scraping do
  namespace :tabelog do
    desc "crawling tabelog restaurant"
    task :crawl => :environment do
      ebisu_station = Station.find_by(name: "恵比寿")
      stations = Station.all

      stations.each_slice(50).count

      stations.each do |station|
        tabelog_scraper = Scraper::Tabelog::TabelogScraper.new(station)
        restaurants = tabelog_scraper.execute
        puts restaurants
      end
    end
  end
end
