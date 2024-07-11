FactoryBot.define do
  factory :user do
    name { "testuser1" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "abcd1234" }
    register_status { "incomplete" }
  end
end
