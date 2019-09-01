namespace :scraping do
  namespace :tabelog do
    desc "crawling tabelog restaurant"
    task :crawl => :environment do
      # stations = Station.where("id >= ?", 527)
      stations = Station.where(scraping_completed: false)

      stations.each_slice(50).to_a.each.with_index(1) do |sliced_station, i|
        sliced_station.each do |station|
          puts "Station id=#{station.id} name=#{station.name} started"
          tabelog_scraper = Scraper::Tabelog::TabelogScraper.new(station)
          restaurants = tabelog_scraper.execute
          puts restaurants
          puts "Station id=#{station.id} name=#{station.name} completed"
          puts "========================================================="
          sleep(30)
        end
        puts "group#{i} finished"
        sleep(60)
      end
    end
  end
end
