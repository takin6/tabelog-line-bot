FactoryBot.define do
  factory :search_history do
    association :chat_unit, factory: :chat_unit

    cache_id  { "#{SecureRandom.hex(8)}-#{Time.zone.now.to_i}" }
    meal_type { "dinner" }
    master_genres { JSON.generate(["フレンチ", "イタリアン"]) }
    custom_meal_genres { ""}
    lower_budget_cents { 2000 }
    upper_budget_cents { 5000 }
    situation {}
    other_requests {}
    completed { false }
  end
end
