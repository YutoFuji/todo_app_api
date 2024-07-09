require 'rails_helper'

RSpec.describe "Api::Profiles", type: :request do
  describe "PUT /profile" do
    let!(:user) { create(:user) }
    let(:params) do
      {
        "name": "changed_name"
      }
    end
    it "名前を変更できること" do
      authenticate_stub(user)
      expect do
        put api_profile_path(id: user.id), params: params, headers: headers
      end.to change { user.reload.name }.from("testuser1").to("changed_name")
    end
    it "データが増えていないこと" do
      authenticate_stub(user)
      users = User.all
      expect do
        put api_profile_path(id: user.id), params: params, headers: headers
      end.not_to change { users.size }.from(1)
    end
  end
end
