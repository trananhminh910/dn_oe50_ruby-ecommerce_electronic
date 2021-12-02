class Admin::BaseController < ApplicationController
  layout "admin/layouts/application"
  before_action :logged_in_user
  before_action :check_user_is_admin
  include SessionsHelper

  def logged_in_user
    return if logged_in?

    flash[:danger] = t "sessions.login_please"
    redirect_to login_url
  end

  def check_user_is_admin
    return if is_admin?

    flash[:danger] = t "sessions.admin_please"
    redirect_to root_url
  end
end
