FactoryBot.define do
  factory :user do
    name { "testuser1" }
    email { "aaa@example.com" }
    password { "password" }
    register_status { "incomplete" }
  end
end
