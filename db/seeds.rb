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

csv = CSV.read(Rails.root.join("db", "seeds", "100_genre.csv"))
csv.shift
csv.each.with_index(1) do |row, index|
  MasterRestaurantGenre.create!(parent_genre: row[0], child_genres: row[1])
end

if Mongo::Restaurants.count == 0
  csv_file = CSV.read(Rails.root.join("db", "seeds", "200_master_restaurants.csv"))
  csv_file.shift
  
  station_id_restaurants_hash = {}
  csv_file.each do |row|
    if station_id_restaurants_hash[row[0]]
      station_id_restaurants_hash[row[0]].push row[1..]
    else
      station_id_restaurants_hash[row[0]] = [row[1..]]
    end
  end

  station_id_restaurants_hash.each do |station_id, restaurants|
    restaurant_wrappers = restaurants.map { |restaurant_row| Mongo::RestaurantWrapper.new(restaurant_row) }
    station = Station.find_by(id: station_id)

    restaurants_hash = Mongo::RestaurantsWrapper.new(station, restaurant_wrappers).to_restaurant_document_from_csv

    Mongo::Restaurants.collection.bulk_write([{ insert_one: restaurants_hash}])
  end
end

# restaurant_csvs = Dir.glob(Rails.root.join('db/seeds/*.csv')).select.each do |file_name|
#   file_name.match(/.+restaurants.csv/).present?
# end

["elasticsearch:create_search_index", "elasticsearch:create_suggest_keyword"].each do |task_name|
  Rake::Task[task_name].invoke
end


