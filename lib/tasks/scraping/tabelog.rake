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

  namespace :tabelog do
    desc "crawling restaurant pictures"
    task :crawl_restaurant_pictures => :environment do
      header = CSV.read(Rails.root.join("db", "seeds", "200_master_restaurants.csv"), headers: true).headers
      header[-1] = "thumbnail_image_urls"

      reference_data = CSV.open(Rails.root.join("db", "seeds", "200_master_restaurants.csv"), "r")
      reference_data.shift
      CSV.open(Rails.root.join("db", "seeds", "201_master_genres_restaurants_ver2.csv"), "w") do |csv|
        csv << header
        reference_data.each.with_index(1) do |row, index|
          pictures = Scraper::Tabelog::TabelogPictureScraper.new(row[-2]).execute
          row[-1] = pictures
          csv << row
          sleep(10)
        end
      end
    end
  end
end


