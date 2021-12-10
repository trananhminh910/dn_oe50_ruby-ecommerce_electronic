class Admin::ProductsController < Admin::BaseController
  def index
    @products = if search_params?
                  search_with_sort params[:search], params[:option]
                else
                  Product.all
                end.page(params[:page]).per(Settings.size.page_record_medium)
  end

  def new
    @product = Product.new
    @product.build_category
  end

  def create
    @product = if add_category_condition?
                 Product.new product_category_params
               else
                 Product.new product_params
               end
    if @product.save
      flash[:success] = t "products.add_success"
      redirect_to admin_products_url
    else
      flash[:danger] = t "products.add_failed"
      render :new
    end
  end

  private

  def add_category_condition?
    product_category_params[:category_attributes][:name].present?
  end

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

  def product_params
    params.require(:product)
          .permit(
            :name, :price, :image, :discount, :residual, :description, :category_id
          )
  end

  def product_category_params
    params.require(:product)
          .permit(
            :name, :price, :image, :discount, :residual, :description,
            category_attributes: [:name, :parent_id]
          )
  end
end
