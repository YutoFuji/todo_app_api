class Api::TodosController < ApplicationController
  before_action :authenticate_user!

  def index
    todos = Todo.published

    render json: todos
  end

  def create
    @todo = current_user.todos.create!(todo_params)

    render json: @todo
  end

  def show
    render json: todo
  end

  def update
    todo.update!(todo_params)

    render json: todo
  end

  def destroy
    todo.destroy

    render :ok
  end

  private

  def todo_params
    params.permit(:title, :content, :status, :target_completion_date, :is_published)
  end

  def todo
    current_user.todos.find(params[:id])
  end
end
