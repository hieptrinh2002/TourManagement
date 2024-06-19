class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper
  include VouchersHelper
  include BookingsHelper

  before_action :set_locale
  helper_method :breadcrumbs

  private

  def set_locale
    session[:locale] = params[:locale] if params[:locale]
    I18n.locale = session[:locale] || I18n.default_locale
  end

  def breadcrumbs
    @breadcrumbs ||= []
  end

  def add_breadcrumb name, path = nil
    breadcrumbs << Breadcrumb.new(name, path)
  end
end
