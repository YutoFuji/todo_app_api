class Api::FavoritesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    current_user.favorites.create!(todo_id: target_todo.id)

    render json: { count: target_todo.favorites.count }
  end

  def destroy
    favorite = current_user.favorites.find(params[:id])
    favorite.destroy!

    render json: { count: target_todo.favorites.count }
  end
  
  private

  def target_todo
    Todo.find(params[:todo_id])
  end
end
