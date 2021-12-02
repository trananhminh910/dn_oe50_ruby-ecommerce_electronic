class Admin::OrdersController < Admin::BaseController
  before_action :fetch_order, only: [:edit, :update, :check_param_in_status]
  before_action :status_settings_params,
                :check_param_in_status,
                only: [:update]

  def index
    if search_params?
      search_with_sort params[:search], params[:option]
      @orders = @orders.page(params[:page])
                       .per(Settings.size.page_record_medium)
    else
      @orders = Order.all
                     .page(params[:page]).per(Settings.size.page_record_medium)
    end
  end

  def edit; end

  def update
    return update_status_reject @order if check_status_param_change? @reject_status
    return update_status_cancel @order if check_status_param_change? @cancel_status
    return update_status_accept @order if check_status_param_change? @accept_status

    update_status_pending @order
  end

  private

  def check_param_in_status
    param_in_status = Order.statuses.key(params[:status].to_i).blank?
    return update_by_status_else @order, t("orders.param_not_in_status") if param_in_status
  end

  def status_settings_params
    @reject_status = Settings.admin.order_status.reject_
    @cancel_status = Settings.admin.order_status.cancel
    @accept_status = Settings.admin.order_status.accept
    @pending_status = Settings.admin.order_status.pending
  end

  def check_status_param_change? status
    status_change = params[:status].to_i
    status == status_change
  end

  def search_params?
    params[:search] && params[:option]
  end

  def update_by_status order, message
    @order = order
    if @order.update(status: params[:status].to_i)
      OrderMailer.change_status_order(@order.user, @order.status).deliver_now
      flash[:info] = message
      redirect_to admin_orders_path
    else
      render edit_admin_order_url @order
    end
  end

  def update_by_status_else order, message
    flash[:danger] = message
    redirect_to edit_admin_order_url order
  end

  def update_status_reject order
    ActiveRecord::Base.transaction do
      @order = order
      if @order.pending?
        update_by_status @order, t("orders.reject_success") + t("orders.admin_email_sent")
      elsif @order.accept?
        update_product_quantity :+
        update_by_status @order, t("orders.reject_success") + t("orders.admin_email_sent")
      else
        update_by_status_else @order, t("orders.reject_failed")
      end
    end
  end

  def update_status_cancel order
    update_by_status_else order, t("orders.cancel_failed")
  end

  def update_status_accept order
    ActiveRecord::Base.transaction do
      @order = order
      if @order.pending?
        update_product_quantity :-
        update_by_status @order, t("orders.accept_success") + t("orders.admin_email_sent")
      else
        update_by_status_else @order, t("orders.accept_failed")
      end
    end
  end

  def update_status_pending order
    update_by_status_else order, t("orders.pending_failed")
  end

  def update_product_quantity operator
    @order.order_details.each do |d|
      product = d.product
      product.residual = product.residual.send operator, d.quantity
      product.save!
    end
  end

  def fetch_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t "sessions.error_not_find"
    redirect_to admin_orders_path
  end

  def search_with_sort search_keyword, option
    @orders = case option
              when Settings.admin.order_option.oldest
                Order.search(search_keyword).order_oldest
              when Settings.admin.order_option.newest
                Order.search(search_keyword).order_newest
              when Settings.admin.order_option.status
                Order.search(search_keyword).order_status
              else
                Order.search search_keyword
              end
  end
end
