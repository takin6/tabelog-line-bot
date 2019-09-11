FactoryBot.define do
  factory :user do
    association :chat_unit, factory: :chat_unit

    line_id { "123456789" }
    name { "testtest" }
    profile_picture_url { "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHHB9Ga_BO0e2BfV2TDt2qkN80EPaauNrR61ZzBSFYh1GX17jNkA" }
  end
end
