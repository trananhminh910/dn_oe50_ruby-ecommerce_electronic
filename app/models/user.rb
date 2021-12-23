class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
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

  class << self
    def from_omniauth auth
      result = User.find_by email: auth.info.email
      return result if result

      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name
        user.uid = auth.uid
        user.provider = auth.provider
      end
    end
  end
end
