namespace :elasticsearch do
  desc "create elasticsearch index for stations"
  task :create_search_index => :environment do
    Station.create_index!
  end

  desc "input elasticsearch documents"
  task :create_suggest_keyword => :environment do
    Station.__elasticsearch__.import
    MasterRestaurantGenre.__elasticsearch__.import
  end

  desc "sample search"
  task :sample_search => :environment do
    test_queries = ["ああああ", "外苑前", "赤坂", "jjjj", "akasaka"]

    test_queries.each do |query|
      response = Station.search(query)
      result = response.to_a[0..4].map do |result_station|
        { id: result_station["_source"][:id], name: result_station["_source"][:name] }
      end
      exact_match = result.select {|station| station[:name].include?(query) }

      puts query
      if exact_match.present?
        puts exact_match
      else
        puts result
      end

      puts "==========================="
    end
  end
end