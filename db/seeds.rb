require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

chat_unit1 = ChatUnit.create!(chat_type: :user)
User.create!(chat_unit: chat_unit1, name: "aさん", line_id: "aaaa", profile_picture_url: "https://thumbs.dreamstime.com/z/comical-face-illustration-facial-expression-31912062.jpg")
chat_unit2 = ChatUnit.create!(chat_type: :user)
User.create!(chat_unit: chat_unit2, name: "bさん", line_id: "bbbb", profile_picture_url: nil)
chat_unit3 = ChatUnit.create!(chat_type: :room)
ChatRoom.create!(chat_unit: chat_unit3, line_id: "sample_room")

LineLiff.create(name: "search_restaurants", liff_id: ENV["LIFF_URL"])

csv = CSV.read(Rails.root.join("db", "seeds", "001_regions.csv"))
csv.shift
csv.each do |id, name|
  Region.create(id: id, name: name)
end

csv = CSV.read(Rails.root.join("db", "seeds", "002_stations.csv"))
csv.shift
csv.each do |id, region_id, name|
  Station.create(id: id, region_id: region_id, name: name)
end

if Mongo::Restaurants.count == 0
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
    station = Station.find_by(name: station_name)
    station.save!
    Mongo::Restaurants.create!(station_id: station.id, max_page: (restaurants.count / 8.0).ceil, restaurants: restaurants)
  end
end

["elasticsearch:create_search_index", "elasticsearch:create_suggest_keyword"].each do |task_name|
  Rake::Task[task_name].invoke
end


