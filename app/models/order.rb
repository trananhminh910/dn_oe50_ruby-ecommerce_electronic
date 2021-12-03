class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :order_details, dependent: :destroy
  enum status: {pending: 0, accept: 1, cancel: 2, reject_: 3}
  enum sort: {oldest: 0, newest: 1, status: 2, default: 3}

  scope :order_oldest, ->{order :updated_at}
  scope :order_newest, ->{order updated_at: :desc}
  scope :order_status, ->{order :status}

  class << self
    def search keyword
      joins(:user)
        .joins(:address)
        .where("users.name LIKE ? or addresses.address LIKE ?", "%#{keyword}%", "%#{keyword}%")
    end
  end
end
