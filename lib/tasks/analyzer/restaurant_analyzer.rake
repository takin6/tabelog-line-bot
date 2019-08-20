require 'csv'

namespace :analyzer do
  namespace :restaurant_analyzer do
    desc "create flex_message_sample"
    task :popular_genres => :environment do
      CSV.open(Rails.root.join("lib", "tasks", "analyzer", "popular_genres.csv"), "w") do |csv|
        csv << ["genre_name"]

        genres = []
        Mongo::Restaurants.all.each do |mongo_restaurants|
          mongo_restaurants.restaurants.each do |restaurant|
            original = restaurant["genre"]
            cleaned_generes = original.split("/")[1].split("、")

            cleaned_generes.map do |genre|
              genre.strip!
              unless genres.include?(genre)
                csv << [genre]
                genres.push(genre)
              end
            end
          end
        end
      end
    end

    namespace :scrape_restaurant_gernes do
    end
    
  end
end