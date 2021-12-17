class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :addresses, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :orders, dependent: :destroy
  enum role: {user: 0, admin: 1}
  enum gender: {female: false, male: true}

  validates :email,
            presence: true,
            uniqueness: true,
            length: {maximum: Settings.length.max_length_email},
            format: {with: URI::MailTo::EMAIL_REGEXP}

  validates :name,
            presence: true,
            length: {in: Settings.length.min_length_username..Settings.length.max_length_username}

  validates :gender,
            presence: true

  validates :password,
            presence: true,
            length: {minimum: Settings.length.min_length_password},
            allow_nil: true
end
