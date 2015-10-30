module Magaz
  class Engine < ::Rails::Engine
    isolate_namespace Magaz
    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: true,
        request_specs: true
      g.fixture_replacement :factory_girl, dir: "spec/factories"
      g.template_engine :haml
    end
    # ---
    config.i18n.load_path += Dir[Magaz::Engine.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ru
  end
end
