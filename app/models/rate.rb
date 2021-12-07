class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :product

  scope :rate_product, ->(product_id){where product_id: product_id}
  scope :check_user_rate, ->(uid, pid){where(user_id: uid).where(product_id: pid)}
end
