class Api::V1::UsersController < Api::V1::ApplicationController
  def create
    @user = User.create(user_params)

    if @user.valid?
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token:}, status: :ok
    else
      render json: {error: I18n.t("api.users.invalid")},
             status: :unprocessable_entity
    end
  end

  def sign_in
    @user = User.find_by(email: user_params[:email])

    if @user&.valid_password?(user_params[:password])
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token:}, status: :ok
    else
      render json: {error: I18n.t("api.login.invalid_credentials")}, status:
      :unprocessable_entity
    end
  end
  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password,
                                 :password_confirmation)
  end
end
