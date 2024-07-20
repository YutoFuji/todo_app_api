FactoryBot.define do
  factory :todo do
    title { "title" }
    status { "status" }
    content { "content" }
    target_completion_date { "2024-07-03T00:00:00Z" }
    is_published { false }
  end
end
