class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product

  scope :fetch_order_details_by_orderid, ->(id){where("order_id = ?", id.to_s)}
end
