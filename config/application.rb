require_relative "boot"
require "rails/all"
Bundler.require(*Rails.groups)

module DnOe50RubyEcommerceElectronic
  class Application < Rails::Application
    config.load_defaults 6.1
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :en

    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.default_url_options = {host: "localhost:3000" }

    config.action_mailer.smtp_settings = {
      address: "smtp.gmail.com",
      port: 587,
      user_name: Figaro.env.gmail_username,
      password: Figaro.env.gmail_password,
      authentication: "plain",
      enable_starttls_auto: true
    }
  end
end
