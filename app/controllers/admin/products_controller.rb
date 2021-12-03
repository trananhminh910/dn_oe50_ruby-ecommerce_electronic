class Admin::ProductsController < Admin::BaseController
  def index
    if search_params?
      search_with_sort params[:search], params[:option]
      @products = @products.page(params[:page])
                           .per(Settings.size.page_record_medium)
    else
      @products = Product.all
                         .page(params[:page])
                         .per(Settings.size.page_record_medium)
    end
  end

  private

  def search_params?
    params[:search] && params[:option]
  end

  def search_with_sort search_keyword, option
    @products = case option
                when Settings.admin.product_option.oldest
                  Product.search(search_keyword).products_oldest
                when Settings.admin.product_option.newest
                  Product.search(search_keyword).products_newest
                when Settings.admin.product_option.price
                  Product.search(search_keyword).asc_order
                else
                  Product.search search_keyword
                end
  end
end
