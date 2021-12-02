class StaticPageController < ApplicationController
  def home
    @categories = Category.by_category
    @brands = Category.by_brand
    @products = Product.all.page(params[:page]).per(Settings.size.page_record_medium).asc_order
  end
end
