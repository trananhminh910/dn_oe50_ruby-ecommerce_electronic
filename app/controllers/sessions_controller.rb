class SessionsController < ApplicationController
  before_action :fetch_user_by_email, only: [:create]
  before_action :logged_in_user, only: [:destroy]
  def new; end

  def create
    if @user&.authenticate params[:session][:password]
      log_in @user
      return redirect_to admin_root_url if @user.admin?

      redirect_to root_url
    else
      flash.now[:danger] = t "sessions.invalid_email_password"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def fetch_user_by_email
    @user = User.find_by email: params.dig(:session, :email).downcase
    return if @user

    flash[:danger] = t "sessions.error_not_find"
    redirect_to root_path
  end
end
