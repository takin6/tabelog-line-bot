require 'csv'

namespace :adhoc do
  namespace :region do
    desc "create seeds file"
    task :create_master_data => :environment do
      CSV.open(Rails.root.join("db", "seeds", "002_stations.csv"), 'w') do |csv|
        csv << ["id", "region_id", "name"]
        station_names = []

        reference_data = CSV.read(Rails.root.join("lib", "tasks", "adhoc",  "csv_eki_13.csv"))
        reference_data.shift
        reference_data.each.with_index(1) do |row, index|
          station_name = row[3]
          next if station_names.find_index(station_name).present?

          csv << [index, 1, station_name]
          station_names.push(station_name)
        end
      end
    end

    desc "delete stations with 0 restaurant"
    task :delete_stations_with_zero_restaurants => :environment do
      Mongo::Restaurants.all.each do |mongo_restaurants|
        if mongo_restaurants.restaurants.count == 0
          station = Station.find_by(name: mongo_restaurants.station_name)
          station.delete
          puts "#{station.name} deleted"
          mongo_restaurants.delete
        end
      end
    end

    desc "recreate master data"
    task :recreate_master_data => :environment do
      CSV.open(Rails.root.join("db", "seeds", "002_stations.csv"), "w") do |csv|
        csv << ["id", "region_id", "name"]

        Station.all.each.with_index(1) do |station, index|
          csv << [index, 1, station.name]
        end
      end
    end
  end
end
