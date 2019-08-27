namespace :hotpepper do
  desc "get large areas list"
  task :get_large_areas_list => :environment do
    result = Hotpepper::ClientWrapper.new.get_middle_areas
    puts result.values
  end

  desc "get restaurants list"
  task :search_restaurants => :environment do
    Hotpepper.ClisntWrapper.new.search_restaurants("外苑前")
  end
end
