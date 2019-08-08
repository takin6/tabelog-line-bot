namespace :scraping do
  namespace :tabelog do
    desc "crawling tabelog restaurant"
    task :crawl => :environment do
      stations = []
      stations.push(Station.find_by(name: "赤坂見附"))
      stations.push(Station.find_by(name: "外苑前"))


      stations.each do |station|
        tabelog_scraper = Scraper::Tabelog::TabelogScraper.new(station)
        restaurants = tabelog_scraper.execute
        p restaurants
      end
    end

    task :output_master_data => :environment do 
      restaurant_keys = ["id", "name", "rating", "genre", "lunch_budget", "dinner_budget", "redirect_url", "thumbnail_image_url"]
      pager_index = 0

      Mongo::Restaurants.all.map do |mongo_restaurant|
        station_name = Station.find(mongo_restaurant.station_id).name
        p station_name

        CSV.open(Rails.root.join("db", "seeds", "00#{3+pager_index}_#{station_name}_restaurants.csv"), 'w') do |csv|
          csv << restaurant_keys
          mongo_restaurant.restaurants.each do |restaurant|
            row_result = []
            restaurant_keys.each do |key|
              row_result.push(restaurant[key])
            end

            csv << row_result
          end
        end

        pager_index += 1
      end
    end
  end
end
