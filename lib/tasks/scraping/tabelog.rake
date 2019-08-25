namespace :scraping do
  namespace :tabelog do
    desc "crawling tabelog restaurant"
    task :crawl => :environment do
      stations = []
      # stations.push(Station.find_by(name: "赤坂見附"))
      # stations.push(Station.find_by(name: "外苑前"))
      stations.push(Station.find_by(name: "御徒町"))


      stations.each do |station|
        tabelog_scraper = Scraper::Tabelog::TabelogScraper.new(station)
        restaurants = tabelog_scraper.execute
        p restaurants
      end
    end
  end
end
