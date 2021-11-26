class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy
  has_many :rates, dependent: :destroy

  scope :asc_order, ->{order :price}

  def check_residual_quantity? quantity_params
    quantity_params.positive? && residual >= quantity_params
  end
end
