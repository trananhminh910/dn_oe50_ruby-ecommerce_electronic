class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  belongs_to :parent, class_name: Category.name, optional: true
  has_many :childrens, class_name: Category.name, foreign_key: :parent_id, dependent: :destroy
end
