class Users::ConfirmationsController < Devise::ConfirmationsController
  protected

  def after_confirmation_path_for resource_name, resource
    if resource.provider == Settings.google
      sign_in(resource)
      flash[:notice] = t "flash.user.login_success"
      root_path
    else
      super
    end
  end
end
