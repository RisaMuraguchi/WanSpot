FactoryBot.define do
  factory :hashtag do
    hashname { Faker::Lorem.characters(number: 10) }
  end
end