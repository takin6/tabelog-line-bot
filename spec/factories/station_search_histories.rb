FactoryBot.define do
  factory :station_search_history do
    association :station, factory: :station
    association :search_history, factory: :search_history

    station_id { create(:station).id }
    search_history_id { create(:search_history).id }
  end
end
