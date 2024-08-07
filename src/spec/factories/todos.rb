FactoryBot.define do
  factory :todo do
    title { "title" }
    status { "status" }
    content { "content" }
    is_published { false }
  end
end
