class DeviseMailerJob < ApplicationJob
  queue_as :mailers

  def perform devise_mailer, method, user_id, *args
    user = User.find(user_id)
    devise_mailer.send(method, user, *args).deliver_later
  end
end
