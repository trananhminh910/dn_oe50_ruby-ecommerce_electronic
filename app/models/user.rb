class User < ApplicationRecord
  has_many :addresses, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :orders, dependent: :destroy
end
