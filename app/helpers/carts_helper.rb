module CartsHelper
  def current_cart
    session[:cart] ||= Array.new
  end

  def find_product_in_cart product
    current_cart.find{|item| item["product_id"] == product.id}
  end
end
