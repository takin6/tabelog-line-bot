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
  end
end
