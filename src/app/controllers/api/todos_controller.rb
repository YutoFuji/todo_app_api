class Api::TodosController < ApplicationController
  before_action :authenticate_user!

  def index
    todos = current_user.todos
    render json: todos
  end

  def create
    @todo = current_user.todos.create!(todo_params)

    if @todo.save!
      render status: :ok
    else
      render :bad_request
    end
  end

  def show
    render json: set_todo
  end

  def update
    set_todo.update!(todo_params)
    if set_todo.save
      render json: set_todo
    else
      render :bad_request
    end
  end

  def destroy
    set_todo.destroy
    render :ok
  end

  private

  def todo_params
    params.permit(:title, :content, :status, :target_completion_date)
  end

  def set_todo
    current_user.todos.find(params[:id])
  end
end
