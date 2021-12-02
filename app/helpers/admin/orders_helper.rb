module Admin::OrdersHelper
  def change_color_order_status order
    if order.pending?
      "warning"
    elsif order.accept?
      "success"
    elsif order.cancel?
      "light"
    elsif order.reject_?
      "danger"
    end
  end

  def fetch_username_by_id user_id
    User.find(user_id).name
  end

  def fetch_address_by_id address_id
    Address.find(address_id).address
  end
end
