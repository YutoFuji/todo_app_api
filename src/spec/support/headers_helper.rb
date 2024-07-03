module HeadersHelpers
  def jwt_token
    "jwt_token"
  end

  def headers
    { Authorization: "Bearer #{jwt_token}" }
  end
end
