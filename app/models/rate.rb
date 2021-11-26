class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :product

  scope :rate_product, ->(product_id){where product_id: product_id}
end
