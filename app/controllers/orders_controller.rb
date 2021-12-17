class OrdersController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  def new
    @order = current_user.orders.build
    @cart_items = get_line_items_in_cart
  end

  def create
    ActiveRecord::Base.transaction do
      @order = current_user.orders.build
      @cart_items = get_line_items_in_cart
      create_order_details
      @order.assign_attributes(order_params)
      @order.save!
      flash[:success] = "Tạo đơn hàng thành công"
      session[:cart] = nil
      redirect_to root_path
    end
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  private

  def order_params
    params.require(:order).permit(:name_customer, :phone_number, :address,
                                  :total_money)
  end

  def create_order_details
    @cart_items.each do |item|
      line_item = {product_id: item[:product].id, quantity: item[:quantity]}
      @order.order_details.build(line_item)
    end
  end
end
