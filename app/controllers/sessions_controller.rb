class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user&.authenticate params.dig(:session, :password)
      log_in user
      flash[:success] = "Welcome back #{user.last_name}!"
      redirect_to user, status: :see_other
    else
      flash.now[:warning] = "Could not create a new session !"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
  end
end
