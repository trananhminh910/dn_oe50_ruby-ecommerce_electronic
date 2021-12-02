class Admin::OrdersController < Admin::BaseController
  def index
    if search_params?
      search_with_sort params[:search], params[:option]
      @orders.page(params[:page])
             .per(Settings.size.page_record_medium)
    else
      @orders = Order.all
                     .page(params[:page]).per(Settings.size.page_record_medium)
    end
  end

  private

  def search_with_sort search_keyword, option
    return @orders = Order.search(search_keyword).order_oldest if option == Settings.admin.order_option.oldest
    return @orders = Order.search(search_keyword).order_newest if option == Settings.admin.order_option.newest
    return @orders = Order.search(search_keyword).order_status if option == Settings.admin.order_option.status

    @orders = Order.search(search_keyword)
  end

  def search_params?
    params[:search] && params[:option]
  end
end
