FactoryBot.define do
  factory :post do
    address { Faker::Lorem.characters(number: 30) }
    caption { Faker::Lorem.characters(number: 100) }
    latitude { 35.6761919 }
    longitude { 139.6503106 }
    user_id { 1 }
    user

    after(:build) do |post|
      post.image.attach(io: File.open('spec/images/dogs.jpg'), filename: 'dogs.jpg', content_type: 'image/jpg')
    end
  end
end