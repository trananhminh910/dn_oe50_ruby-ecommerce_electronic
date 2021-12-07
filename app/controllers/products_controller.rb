class ProductsController < ApplicationController
  before_action :fetch_product, only: [:show, :rating, :check_user_rated_product?]

  def show
    @rates = Rate.rate_product(params[:id])
    @existed_rate = Rate.check_user_rate(current_user.id, @product.id).first if check_user_rated_product?
  end

  def rating
    if current_user
      rate = Rate.new
      rate.rating = params[:rate_num]
      rate.content = ""
      rate.user_id = current_user.id
      rate.product_id = @product.id
      save_or_update_rating rate
      flash[:success] = t "rating.rating_success"
    else
      flash[:danger] = t "rating.rating_failed"
    end
    respond_to do |format|
      format.html{redirect_to @product}
      format.js
    end
  end

  private

  def save_or_update_rating rate
    if check_user_rated_product?
      @existed_rate = Rate.check_user_rate(rate.user_id, rate.product_id).first
      @existed_rate.update_column :rating, params[:rate_num]
    else
      rate.save
    end
  end

  def check_user_rated_product?
    Rate.check_user_rate(current_user.id, @product.id).present? if current_user
  end

  def fetch_product
    @product = Product.find_by id: params[:id]
    return if @product.present?

    flash[:danger] = t "flash.not_found_product"
    redirect_to root_url
  end
end
