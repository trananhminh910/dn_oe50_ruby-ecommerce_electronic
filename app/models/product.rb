class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :destroy
  has_many :rates, dependent: :destroy
  accepts_nested_attributes_for :category, allow_destroy: true
  has_one_attached :image

  ransack_alias :product, :name_or_description

  scope :product_order, ->(field){order field}
  scope :searchs, ->(keywrd){where("products.name LIKE ? or products.description LIKE ?", "%#{keywrd}%", "%#{keywrd}%")}

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

  ransacker :created_at, type: :date do
    Arel.sql("date(products.created_at)")
  end

  def self.ransackable_attributes auth_object = nil
    if auth_object == :admin
      super
    else
      super & %w(product name description price created_at)
    end
  end
end
