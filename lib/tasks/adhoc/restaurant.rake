require 'csv'

namespace :adhoc do
  namespace :restaurant do
    desc "load restaurant genres"
    task :load_genres => :environment do
      if MasterRestaurantGenre.count > 0
        MasterRestaurantGenre.all.map(&:delete)
      end

      reference_data = CSV.read(Rails.root.join("db", "seeds", "100_genre.csv"))
      reference_data.shift
      reference_data.each.with_index(1) do |row, index|
	      MasterRestaurantGenre.create!(parent_genre: row[0], child_genres: row[1])
        puts "#{row[0]} was created"
      end
    end

    desc "add master_genres to mongo_restaurants"
    task :add_master_genres_to_mongo_restaurants => :environment do
      master_restaurant_genres_to_a = MasterRestaurantGenre.all.map(&:to_h)

      Mongo::Restaurants.all.map do |mongo_restaurants|
        restaurants = []

        mongo_restaurants.restaurants.map do |restaurant|
          genres_arr = restaurant["genre"].split("/")[1].split("、").map(&:strip)
          result = []
          master_genres = master_restaurant_genres_to_a.dup

          genres_arr.each do |genre|
            master_genres.map do |master_genre|
              if master_genre[:child_genres].include?(genre)
                result.push(master_genre)
                master_genres.delete(master_genre)
              end
            end
          end

          original_genre_str = restaurant["genre"]
          restaurant.delete("genre")
          restaurant.store("area_genre", original_genre_str)
          restaurant.store("master_genres", result.map {|genre| genre.dig(:parent_genre)})
          restaurants.push(restaurant)
        end

        copied_mongo_restaurants = mongo_restaurants.dup
        mongo_restaurants.delete
        copied_mongo_restaurants.restaurants = restaurants
        copied_mongo_restaurants.save!
      end
    end

    desc "analyze genres for each restaurant"
    task :categorize_restaurants => :environment do
      # child_genres = "和食店、和食レストラン日本料理・割烹・ 懐石、お好み焼き、沖縄料理、おでん、懐石・会席料理、割烹・小料理、精進料理、京料理、豆腐料理・湯葉料理、麦とろ、釜飯、もつ料理、くじら料理、牛タン、ろばた焼き、和食（その他）"
      # response = MasterRestaurantGenre.search(child_genres)
      master_restaurant_genres_to_a = MasterRestaurantGenre.all.map(&:to_h)

      File.open(Rails.root.join("lib", "tasks", "adhoc", "result.txt"), "w") do |file|
        Mongo::Restaurants.all.map do |mongo_restaurant|
          mongo_restaurant.restaurants.map do |restaurant|
            genres_arr = restaurant["area_genre"].split("/")[1].split("、").map(&:strip)
            genre_categories = []
            master_genres = master_restaurant_genres_to_a.dup

            genres_arr.each do |genre|
              master_genres.map do |master_genre|
                if master_genre[:child_genres].include?(genre)
                  genre_categories.push(master_genre)
                  master_genres.delete(master_genre)
                  break
                end
              end
            end

            file.puts genres_arr
            if genre_categories.count === 0
              puts genres_arr
            else
              genre_categories.each do |genre_category|
                file.puts "parent_gerne = " + genre_category.dig(:parent_genre)
              end
            end
            file.puts "====================="
          end
        end
      end
    end

    desc "output to master data"
    task :output_to_master_data => :environment do 
      restaurant_keys = ["station_id", "id", "name", "rating", "area_genre", "master_genres", "lunch_budget", "dinner_budget", "redirect_url", "thumbnail_image_url"]
      pager_index = 0

      CSV.open(Rails.root.join("db", "seeds", "300_master_restaurants.csv"), 'w') do |csv|
        csv << restaurant_keys

        Mongo::Restaurants.all.map do |mongo_restaurant|
          station_id = mongo_restaurant.station_id
          p station_id

          mongo_restaurant.restaurants.each do |restaurant|
            row_result = [station_id]
            restaurant_keys[1..].each do |key|
              row_result.push(restaurant[key])
            end

            csv << row_result
          end
        end
      end
    end
  end
end




