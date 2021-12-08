require_relative "boot"
require "rails/all"
Bundler.require(*Rails.groups)

module DnOe50RubyEcommerceElectronic
  class Application < Rails::Application
    config.load_defaults 6.1
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :en
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
