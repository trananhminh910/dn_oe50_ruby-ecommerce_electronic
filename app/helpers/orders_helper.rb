module OrdersHelper
  def change_color_order_status order
    if order.pending?
      "warning"
    elsif order.accept?
      "success"
    elsif order.cancel?
      "default"
    elsif order.reject_?
      "danger"
    end
  end
end
