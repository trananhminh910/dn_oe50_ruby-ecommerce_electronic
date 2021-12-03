class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy
  has_many :rates, dependent: :destroy
  enum sort: {oldest: 0, newest: 1, price: 2, default: 3}

  scope :asc_order, ->{order :price}
  scope :products_oldest, ->{order :updated_at}
  scope :products_newest, ->{order updated_at: :desc}
  scope :search, ->(keywrd){where("products.name LIKE ? or products.description LIKE ?", "%#{keywrd}%", "%#{keywrd}%")}

  def check_residual_quantity? quantity_params
    quantity_params.positive? && residual >= quantity_params
  end
end
