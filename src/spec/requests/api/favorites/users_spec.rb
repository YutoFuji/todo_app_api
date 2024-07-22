require 'rails_helper'

RSpec.describe "Api::Favorites::Users", type: :request do
  let(:user) { create(:user) }
  let!(:todo) { create(:todo, user_id: user.id, is_published: true) }
  let!(:favorite) do
    create :favorite, user_id: user.id, todo_id: todo.id
  end

  describe "GET /todos/{todo_id}/favorites/users" do
    let(:user2) { create(:user) }
    let!(:favorite2) do
      create :favorite, user_id: user2.id, todo_id: todo.id
    end
    it "いいねしているユーザーが配列で返ること" do
      authenticate_stub(user)
      get api_todo_favorites_users_path(user_id: user.id, todo_id: todo.id), headers: headers
      expect(json_response.size).to eq 2
      expect(json_response[0]["id"]).to eq(user.id)
      expect(json_response[0]["name"]).to eq(user.name)
      expect(json_response[0]["email"]).to eq(user.email)
      expect(json_response[0]["register_status"]).to eq(user.register_status)
    end
  end
end
