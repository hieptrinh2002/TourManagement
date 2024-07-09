class Api::V1::ApplicationController < ActionController::API
  include Pagy::Backend

  def encode_token payload
    JWT.encode(payload, "salt")
  end

  def decode_token
    auth_header = request.headers["Authorization"]
    return nil unless auth_header

    token = auth_header.split(" ")[1]
    begin
      JWT.decode(token, "salt", true, algorithm: "HS256")
    rescue JWT::DecodeError
      nil
    end
  end

  def authorized_user
    decoded_token = decode_token
    return nil unless decoded_token

    user_id = decoded_token[0]["user_id"]
    @user = User.find_by(id: user_id)

    return nil unless @user && @user.role.to_sym == :admin

    @user
  end

  def authorized
    return if authorized_user

    render json: {error: I18n.t("api.unauthorized_action")}, status:
    :unauthorized
  end
end
