module ProductsHelper
  def rated num, user_rated_product
    if user_rated_product && (num + 1) <= user_rated_product.rating.to_i
      "checked"
    else
      ""
    end
  end
end
