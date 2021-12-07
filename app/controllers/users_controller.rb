class UsersController < ApplicationController
  before_action :fetch_user, only: [:show_buy_history]

  def show_buy_history
    @orders = @user.orders
  end

  def show_buy_history_details
    @order = Order.find_by id: params[:order_id]
    @order_details = OrderDetail.fetch_order_details_by_orderid params[:order_id]
  end

  private

  def fetch_user
    @user = User.find_by id: params[:id]
    return if @user.present?

    flash[:danger] = t "users.not_found_user"
    redirect_to root_url
  end
end
