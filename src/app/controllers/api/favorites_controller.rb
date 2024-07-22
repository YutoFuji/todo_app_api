class Api::FavoritesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_todo, only: %i[create destroy]

  def create
    current_user.favorites.create!(todo_id: @todo.id)

    render json: { count: @todo.favorites.count }
  end

  def destroy
    favorite = current_user.favorites.find(params[:id])
    favorite.destroy!

    render json: { count: @todo.favorites.count }
  end

  private

  def set_todo
    @todo = Todo.find(params[:todo_id])
  end
end
