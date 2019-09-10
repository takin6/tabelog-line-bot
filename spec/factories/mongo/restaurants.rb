FactoryBot.define do
  factory :mongo_restaurants, class: Mongo::Restaurants do

    station_id { create(:station).id }
    max_page { 20 }
    meal_genres { [] }
    restaurants { [] }
  end
end