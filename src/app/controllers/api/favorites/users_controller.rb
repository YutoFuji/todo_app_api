class Api::Favorites::UsersController <  Api::FavoritesController
  before_action :authenticate_user!, only: %i[index]
  before_action :set_todo, only: %i[index]

  def index
    favorite = Favorite.where(todo_id: @todo.id)
    users = User.where(id: favorite.pluck(:user_id))

    render json: users, each_serializer: UserSerializer
  end
end
