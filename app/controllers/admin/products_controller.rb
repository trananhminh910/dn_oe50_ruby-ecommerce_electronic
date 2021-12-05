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
