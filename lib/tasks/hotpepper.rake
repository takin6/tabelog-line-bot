namespace :hotpepper do
  desc "get large areas list"
  task :get_middle_areas => :environment do
    result = Hotpepper::ClientWrapper.new.get_middle_areas("Z011")
    puts result.values
  end
  
  desc "get small areas"
  task :get_small_areas => :environment do
    client_wrapper = Hotpepper::ClientWrapper.new

    middle_areas_result = client_wrapper.get_middle_areas("Z011")

    middle_areas_result.values["results"]["middle_area"].map do |middle_area|
      middle_area_code = middle_area["code"]
      client_wrapper.get_small_areas(middle_area_code)
    end
  end

  desc "get region json"
  task :create_regions_json => :environment do
    large_area_wrapper = Hotpepper::Region::LargeAreaWrapper.new("東京", "Z011")
    File.open(Rails.root.join("spec", "fixtures", "regions.json"), "w") do |file|
      file.puts JSON.pretty_generate(large_area_wrapper.large_area_to_h)
    end
  end

  desc "get restaurants list"
  task :search_restaurants => :environment do
    file = File.open(Rails.root.join("spec", "fixtures", "regions.json"))
    regions = JSON.parse(file.read)
    result = Hotpepper::ClientWrapper.new.search_restaurants_by_region(regions["areas"].first["regions"].first["code"]).values

    File.open(Rails.root.join("spec", "fixtures", "smaple_restaurants_ginza.json"), "w") do |file|
      file.puts JSON.pretty_generate(result)
    end
  end
end
