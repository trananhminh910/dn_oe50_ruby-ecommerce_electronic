class Admin::OrdersController < Admin::BaseController
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
end
