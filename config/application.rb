require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Carrefour2aMao
  class Application < Rails::Application
    # Bakcground jobs with SideKiq
    config.active_job.queue_adapter = :sidekiq

    config.i18n.default_locale = :'pt-BR'

    config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: true
      generate.fixture_replacement :factory_bot, dir: "spec/factories"
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    #Fix simple form authenticity issue
    Rails.configuration.action_controller.per_form_csrf_tokens = true

  end
end
