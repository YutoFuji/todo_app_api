require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let(:user) { create(:user) }
  let!(:todo) { create(:todo, user_id: user.id, is_published: true) }

  describe "POST /todos/{todo_id}/favorites" do
    it "該当Todoのいいねの数が増えていること" do
      authenticate_stub(user)
      favorites = todo.favorites.all
      expect {
        post api_todo_favorites_path(user_id: user.id, todo_id: todo.id), headers: headers
      }.to change(favorites, :count).by(+1)
    end
    context "もう一度同じ投稿にいいねをしたとき" do
      let!(:favorite) do
        create :favorite, user_id: user.id, todo_id: todo.id
      end
      it "エラーが起こること" do
        authenticate_stub(user)
        post api_todo_favorites_path(user_id: user.id, todo_id: todo.id), headers: headers
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "DELETE /todos/{todo_id}/favorides" do
    let!(:favorite) do
      create :favorite, user_id: user.id, todo_id: todo.id
    end
    it "該当Todoのいいねの数が減っていること" do
      authenticate_stub(user)
      favorites = todo.favorites.all
      expect {
        delete api_todo_favorite_path(user_id: user.id, todo_id: todo.id, id: favorite.id), headers: headers
      }.to change(favorites, :count).by(-1)
    end
  end
end
