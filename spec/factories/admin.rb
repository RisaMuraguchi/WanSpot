FactoryBot.define do
  factory :admin do
    email { "wanspot.com" }
    password { "wanspot" }
    password_confirmation { "wanspot" }
  end
end