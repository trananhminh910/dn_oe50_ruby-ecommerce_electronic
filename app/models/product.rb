class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy
  has_many :rates, dependent: :destroy

  scope :product_order, ->(field){order field}
  scope :search, ->(keywrd){where("products.name LIKE ? or products.description LIKE ?", "%#{keywrd}%", "%#{keywrd}%")}

  def check_residual_quantity? quantity_params
    quantity_params.positive? && residual >= quantity_params
  end
end
