require 'rails_helper'

RSpec.describe "Todos", type: :request do
  let!(:user) { create(:user) }
  let!(:user2) {create(:user) }
  let!(:todo) { create(:todo, user_id: user.id, is_published: true) }

  describe "GET /todos" do
    let!(:todo2) { create(:todo, user_id: user2.id, is_published: true) }
    let!(:todo3) { create(:todo, user_id: user2.id) }
    it "公開されているTodoのみを取得できること" do
      authenticate_stub(user)
      get api_todos_path(user_id: user.id), headers: headers
      expect(json_response.size).to eq 2
      expect(json_response[0]["id"]).to eq(todo.id)
      expect(json_response[0]["title"]).to eq(todo.title)
      expect(json_response[0]["content"]).to eq(todo.content)
      expect(json_response[0]["status"]).to eq(todo.status)
      expect(json_response[0]["is_published"]).to eq(todo.is_published)
      expect(json_response[0]["user_id"]).to eq(user.id)
    end
  end

  describe "POST /todos" do
    let(:params) do
      {
        title: "example_title",
        content: "example_content",
        status: "example_status",
        is_published: true
      }
    end
    it "Todoを作成できること" do
      authenticate_stub(user)
      post api_todos_path(user_id: user.id), params: params, headers: headers
      expect(response).to have_http_status(200)
    end
    it "データが増えていること" do
      authenticate_stub(user)
      todos = user.todos.all
      expect {
        post api_todos_path(user_id: user.id), params: params, headers: headers
      }.to change(todos, :count).by(+1)
    end
    let(:blank_params) do
      {
        title: "example_title",
        content: "",
        status: "example_status",
      }
    end
    context "空欄があったとき" do
      it "Todoを作成失敗すること" do
        authenticate_stub(user)
        post api_todos_path(user_id: user.id), params: blank_params, headers: headers
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "GET /todos/{id}" do
    # 別のユーザーがtodo作成していることを再現
    let!(:user2) { create(:user) }
    let!(:todo3) { create(:todo, user_id: user2.id) }

    it "Todoを一件取得できること" do
      authenticate_stub(user)
      get api_todo_path(user_id: user.id, id: todo.id), headers: headers
      expect(json_response["id"]).to eq(todo.id)
      expect(json_response["title"]).to eq(todo.title)
      expect(json_response["content"]).to eq(todo.content)
      expect(json_response["status"]).to eq(todo.status)
      expect(json_response["user_id"]).to eq(user.id)
    end
  end

  describe "PUT /todos/{id}" do
    let(:params) do
      {
        title: "changed_title",
      }
    end
    it "Todoが更新されていること" do
      authenticate_stub(user)
      expect do
        put api_todo_path(user_id: user.id, id: todo.id), params: params, headers: headers
      end.to change { todo.reload.title }.from("title").to("changed_title")
    end
    it "データが増えていないこと" do
      authenticate_stub(user)
      todos = user.todos.all
      expect do
        put api_todo_path(user_id: user.id, id: todo.id), params: params, headers: headers
      end.not_to change { todos.size }.from(1)
    end
  end

  describe "DELETE /todos/{id}" do
    it "削除され、データが減っていること" do
      authenticate_stub(user)
      todos = user.todos.all
      expect {
        delete api_todo_path(user_id: user.id, id: todo.id), headers: headers
      }.to change(todos, :count).by(-1)
    end
  end
end
