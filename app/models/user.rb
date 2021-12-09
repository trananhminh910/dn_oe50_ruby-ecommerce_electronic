class User < ApplicationRecord
  attr_accessor :remember_token
  has_many :addresses, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :orders, dependent: :destroy
  enum role: {user: 0, admin: 1}
  enum gender: {Male: "0", Female: "1"}

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

  has_secure_password
  has_secure_password :recovery_password, validations: false

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def not_remember
    update_column :remember_digest, nil
  end
end
