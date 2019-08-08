require 'csv'

namespace :mongo do
  namespace :mongo_restaurants do
    desc "create master_data"
    task :create_master_data => :environment do
      restaurant_csvs = Dir.glob(Rails.root.join('db/seeds/*.csv')).select.each do |file_name|
        file_name.match(/.+restaurants.csv/).present?
      end
      restaurant_keys = ["id", "name", "rating", "genre", "lunch_budget", "dinner_budget", "redirect_url", "thumbnail_image_url"]
      restaurant_csvs.each do |file_name|
        csv_file = CSV.read(file_name)
        csv_file.shift

        restaurants = []
        csv_file.each do |row|
          id, name, rating, genre, lunch_budget, dinner_budget, redirect_url, thumbnail_image_url = row

          restaurant_hash = {
            id: id,
            name: name,
            rating: rating,
            genre: genre,
            lunch_budget: lunch_budget.is_a?(String) ? lunch_budget.split('[')[1].split("]")[0].split(",").map(&:to_i) : lunch_budget,
            dinner_budget: dinner_budget ? dinner_budget.split('[')[1].split("]")[0].split(",").map(&:to_i) : dinner_budget,
            redirect_url: redirect_url,
            thumbnail_image_url: thumbnail_image_url
          }

          restaurants.push(restaurant_hash)
        end
        
        station_name = file_name.split("_")[1]
        Mongo::Restaurants.create!(station_id: Station.find_by(name: station_name).id, max_page: (restaurants.count / 8.0).ceil, restaurants: restaurants)
      end

    end
  end
end
