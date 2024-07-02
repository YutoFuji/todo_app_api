require 'rails_helper'
RSpec.describe UsersHelper, type: :helper do
  let(:jwt_token) { "jwt_token" }
  let(:headers) do
    {
      "ACCEPT": "application/json",
      "Authorization": "Bearer #{jwt_token}",
    }
  end
end
