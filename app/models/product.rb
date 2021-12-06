class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy
  has_many :rates, dependent: :destroy
  accepts_nested_attributes_for :category, allow_destroy: true
  enum sort: {oldest: 0, newest: 1, price: 2, default: 3}
  has_one_attached :image

  scope :asc_order, ->{order :price}
  scope :products_oldest, ->{order :updated_at}
  scope :products_newest, ->{order updated_at: :desc}
  scope :search, ->(keywrd){where("products.name LIKE ? or products.description LIKE ?", "%#{keywrd}%", "%#{keywrd}%")}

  validates :image,
            content_type:
            {
              in: Settings.admin.product.image.format,
              message: I18n.t("products.image_format_message")
            },
            size:
            {
              less_than: Settings.admin.product.image.less_than.megabytes,
              message: I18n.t("products.image_format_size")
            }

  validates :name,
            presence: true,
            length: {maximum: Settings.product.max_length_name}

  validates :price,
            presence: true

  validates :discount,
            presence: true,
            length: {in: Settings.product.min_discount..Settings.product.max_discount}

  validates :residual,
            presence: true,
            length: {maximum: Settings.product.max_residual}

  validates :description,
            presence: true

  def check_residual_quantity? quantity_params
    quantity_params.positive? && residual >= quantity_params
  end

  def display_image
    image.variant resize_to_limit: [Settings.admin.product.image.width, Settings.admin.product.image.height]
  end

  def display_image_200
    image.variant resize_to_limit: [Settings.admin.product.image.width_200, Settings.admin.product.image.height_200]
  end
end
