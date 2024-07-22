# User
5.times do |n|
  User.create!(
    name: "テスト太郎#{n + 1}",
    email: "testexample#{n + 1}@test.com",
    password: "password123",
    register_status: "complete"
  )
end

# Todo
User.all.each do |user|
  user.todos.create!(
    title: 'タイトル',
    status: 'テキストテキストテキストテキスト',
    content: 'コンテンツコンテンツコンテンツ',
    target_completion_date: '2024-07-03',
    is_published: 'true'
  )
end

# Favorite
User.all.each do |user|
  todos = Todo.all.sample(3)
  todos.each do |todo|
    Favorite.create!(
      user: user,
      todo: todo
    )
  end
end
