FactoryBot.define do
  factory :user_community do
    user_id { create(:user).id }
    community_type { "room" }
  end
end
