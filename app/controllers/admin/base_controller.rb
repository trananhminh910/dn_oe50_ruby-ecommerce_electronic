class Admin::BaseController < ApplicationController
  layout "admin/layouts/application"
  before_action :logged_in_user
  before_action :check_user_is_admin
  before_action :authenticate_user!

  def logged_in_user
    return if user_signed_in?

    flash[:danger] = t "sessions.login_please"
    redirect_to signin_path
  end

  def check_user_is_admin
    return if current_user&.admin?

    flash[:danger] = t "sessions.admin_please"
    redirect_to root_url
  end
end
