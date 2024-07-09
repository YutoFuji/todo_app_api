class Api::ProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[update]

  def update
    current_user.update!(name: params["name"])

    render json: current_user, serializer: UserSerializer
  end
end
