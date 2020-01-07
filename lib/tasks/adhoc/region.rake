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

    desc "create station master data"
    task :create_station_master_data => :environment do
      json = JSON.load(File.open(Rails.root.join("lib", "tasks", "adhoc", "data", "region_mapping_hotpepper.json")))

      CSV.open(Rails.root.join("db", "seeds", "004_stations.csv"), "w") do |csv|
        csv << ["id", "area_id", "name"]

        Station.all.each.with_index(1) do |station, station_index|
          found = false
          json.each.with_index(1) do |area_block, area_index|
            area_name = area_block[0]
            stations = area_block[1]
            if stations.include?(station.name)
              csv << [station.id, area_index, station.name]
              found = true
              break
            end
          end

          csv << [station.id, nil, station.name] unless found
        end
      end
    end

    desc "create area master data"
    task :create_area_master_data => :environment do
      json = JSON.load(File.open(Rails.root.join("lib", "tasks", "adhoc", "data", "region_mapping_hotpepper.json")))

      CSV.open(Rails.root.join("db", "seeds", "003_areas.csv"), "w") do |csv|
        csv << ["id", "region_id", "name"]

        json.keys.map(&:to_s).each.with_index(1) do |area_name, index|
          csv << [index, 1, area_name]
        end
      end
    end

    # from hotpepper api
    desc "format small_area hotpepper"
    task :format_small_area => :environment do
      json = JSON.load(File.open(Rails.root.join("lib", "tasks", "adhoc", "data", "hotpepper_small_area.json")))
      small_areas = json["results"]["small_area"]
      result = small_areas.map do |small_area|
        if small_area["large_area"]["name"] == "東京"
          small_area
        end
      end

      file = File.open(Rails.root.join("lib", "tasks", "adhoc", "data", "hotpepper_small_area.json"), 'w')
      file << JSON.pretty_generate(result.compact)
    end

    # from hotpepper api
    desc "find_small_region hotpepper"
    task :find_small_region => :environment do
      stations = Station.all
      result = {}
      area_blocks = JSON.load(File.open(Rails.root.join("lib", "tasks", "adhoc", "data", "hotpepper_small_area.json")))
      not_found = 0

      stations.each.with_index do |station, index|
        found = false
        station_name = station.name

        area_blocks.each do |area_block|
          if area_block["name"].include?(station_name) || station_name.include?(area_block["name"])
            middle_area_name = area_block["middle_area"]["name"]
            found = true

            if result[middle_area_name] == nil
              result[middle_area_name] = {
                "id": index,
                "stations": [station_name]
              }
            else
              result[middle_area_name]["stations"].append(station_name)
            end

            found = true
          else
            is_substring = area_block["middle_area"]["name"].split("・").map do |area_name|
              area_name.include?(station_name) || station_name.include?(area_name)
            end.any?

            if is_substring
              middle_area_name = area_block["middle_area"]["name"]
              if result[middle_area_name] == nil
                result[middle_area_name] = {
                  "id": index,
                  "stations": [station_name]
                }
              else
                result[middle_area_name]["stations"].append(station_name)
              end

              found = true
            end
          end

          break if found
        end

        unless found
          not_found += 1
          puts station_name
        end
      end

      puts "not_found = " + not_found.to_s

      file = File.open(Rails.root.join("lib", "tasks", "adhoc", "data", "region_mapping_hotpepper.json"), "w")
      file.puts(JSON.pretty_generate(result))
    end
  end
end
