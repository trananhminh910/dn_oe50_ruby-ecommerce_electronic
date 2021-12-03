class CartsController < ApplicationController
  before_action :find_product,
                :get_line_item,
                :check_residual_quantity?,
                only: [:add_to_cart]
  before_action :logged_in_user, only: [:index, :add_to_cart]

  def index
    @cart_items = get_line_items_in_cart
  end

  def add_to_cart
    if @item
      @item["quantity"] += params[:quantity].to_i
      flash[:info] = t "flash.cart_update"
    else
      current_cart << {
        product_id: @product.id, quantity: params[:quantity].to_i
      }
      flash[:success] = t "flash.cart_success"
    end
    session[:cart] = current_cart
    redirect_to root_path
  end

  private

  def check_residual_quantity?
    quantity = if @item
                 @item["quantity"] + params[:quantity].to_i
               else
                 params[:quantity].to_i
               end
    return if @product.check_residual_quantity? quantity

    flash[:danger] = t "flash.not_enough"
    redirect_to root_path
  end

  def get_line_item
    @item = find_product_in_cart @product
  end
end
