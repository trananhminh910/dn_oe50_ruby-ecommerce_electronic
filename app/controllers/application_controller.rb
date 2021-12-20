class ApplicationController < ActionController::Base
  before_action :set_locale
  include CartsHelper
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def after_sign_in_path_for resource_or_scope
    if current_user&.admin?
      stored_location_for(resource_or_scope) || admin_root_path
    else
      stored_location_for(resource_or_scope) || root_path
    end
  end

  def configure_permitted_parameters
    added_attrs = [:name, :gender, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    return if @product

    flash[:danger] = t "pages.empty_product"
    redirect_to root_path
  end
end
