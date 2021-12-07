class UsersController < ApplicationController
  before_action :fetch_user, only: [:show_buy_history]
  before_action :fetch_order, only: [:show_buy_history_details, :cancel_order]

  def show_buy_history
    @orders = @user.orders
  end

  def show_buy_history_details
    @order_details = OrderDetail.fetch_order_details_by_orderid params[:order_id]
  end

  def cancel_order
    ActiveRecord::Base.transaction do
      if @order.update(status: Settings.admin.order_status.cancel)
        flash[:succes] = t "users.cancel_succes"
      else
        flash[:danger] = t "users.cancel_failed"
      end
      redirect_to buy_history_details_path @order
    end
  end

  private

  def fetch_order
    @order = Order.find_by id: params[:order_id]
    return if @order.present?

    flash[:danger] = "order not_found_user"
    redirect_to root_url
  end

  def fetch_user
    @user = User.find_by id: params[:id]
    return if @user.present?

    flash[:danger] = t "users.not_found_user"
    redirect_to root_url
  end
end
