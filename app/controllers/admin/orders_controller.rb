class Admin::OrdersController < Admin::BaseController
  before_action :fetch_order, only: [:edit, :update]

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
    case params[:status].to_i
    when Settings.admin.order_status.reject_
      update_status_reject @order
    when Settings.admin.order_status.cancel
      update_status_cancel @order
    when Settings.admin.order_status.accept
      update_status_accept @order
    else
      update_by_status_else @order, t("orders.pending_failed")
    end
  end

  def fetch_order
    @order = Order.find_by id: params.dig(:id)
    return if @order

    flash[:danger] = t "sessions.error_not_find"
    redirect_to admin_orders_path
  end

  private

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

  def search_params?
    params[:search] && params[:option]
  end

  def update_by_status order, message
    @order = order
    if @order.update_column :status, params[:status]
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
    @order = order
    if @order.pending? || @order.accept?
      update_by_status @order, t("orders.reject_success") + t("orders.admin_email_sent")
    else
      update_by_status_else @order, t("orders.reject_failed")
    end
  end

  def update_status_cancel order
    @order = order
    if @order.pending? || @order.accept?
      update_by_status @order, t("orders.cancel_success") + t("orders.admin_email_sent")
    else
      update_by_status_else @order, t("orders.cancel_failed")
    end
  end

  def update_status_accept order
    @order = order
    if @order.pending?
      update_by_status @order, t("orders.accept_success") + t("orders.admin_email_sent")
    else
      update_by_status_else @order, t("orders.accept_failed")
    end
  end
end
