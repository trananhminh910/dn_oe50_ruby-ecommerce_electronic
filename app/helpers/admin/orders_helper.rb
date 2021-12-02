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

  def fetch_username_by_id order
    order.user.name
  end

  def fetch_address_by_id order
    order.address.name
  end

  def render_select_tag
    select_tag :status, options_for_select(Order.statuses,
                                           Order.statuses[@order.status]),
               class: "select-change-order form-control"
  end
end
