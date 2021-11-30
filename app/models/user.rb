class User < ApplicationRecord
  has_many :addresses, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :orders, dependent: :destroy
  enum role: {user: 0, admin: 1}

  validates :email,
            presence: true,
            uniqueness: true,
            length: {maximum: Settings.length.max_length_email},
            format: {with: URI::MailTo::EMAIL_REGEXP}

  validates :name,
            presence: true,
            length: {in: Settings.length.min_length_username..Settings.length.max_length_username}

  validates :gender,
            presence: true,
            inclusion: [true, false]

  validates :password,
            presence: true,
            length: {minimum: Settings.length.min_length_password},
            allow_nil: true

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end

  has_secure_password
end
