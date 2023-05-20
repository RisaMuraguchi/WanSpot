FactoryBot.define do
  factory :post do
    address { Faker::Lorem.characters(number: 30) }
    caption { Faker::Lorem.characters(number: 300) }
    latitude { "35.6761919" }
    longitude { "139.6503106" }
    user_id { "1" }
    likes_count { "0" }
    comments_count { "0" }
    user
  end
end