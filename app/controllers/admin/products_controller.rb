class Admin::ProductsController < Admin::BaseController
  def index
    @products = if search_params?
                  search_with_sort params[:search], params[:option]
                else
                  Product.all
                end.page(params[:page]).per(Settings.size.page_record_medium)
  end

  private

  def search_params?
    params[:search] && params[:option]
  end

  def search_with_sort search_keyword, option
    search_product = Product.search(search_keyword)
    settings = Settings.admin.product_option
    @products = case option
                when settings.oldest
                  search_product.product_order :updated_at
                when settings.newest
                  search_product.product_order updated_at: :desc
                when settings.price
                  search_product.product_order :price
                when settings.price_desc
                  search_product.product_order price: :desc
                else
                  Product.all
                end
  end
end
