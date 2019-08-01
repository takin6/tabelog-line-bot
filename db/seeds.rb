require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

LineLiff.create(name: "search_restaurants", liff_id: "1594882845-n4DqaZ6z")

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
