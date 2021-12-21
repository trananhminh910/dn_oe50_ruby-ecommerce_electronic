class StaticPageController < ApplicationController
  def home
    @categories = Category.by_category
    @brands = Category.by_brand
    @q = Product.joins(:category).ransack(params[:q], auth_object: set_ransack_auth_object)
    @products = @q.result.page(params[:page]).per(Settings.size.page_record_medium).product_order :price
  end

  def set_ransack_auth_object
    current_user&.admin? ? :admin : nil
  end
end
