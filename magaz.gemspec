$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "magaz/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "magaz"
  s.version     = Magaz::VERSION
  s.authors     = ["Nikolay Mikhaylichenko"]
  s.email       = ["nn.mikh@yandex.ru"]
  s.homepage    = ""
  s.summary     = "Summary of Magaz."
  s.description = "Description of Magaz."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.4"
  s.add_dependency "haml-rails", "~> 0.9"
  s.add_dependency "jquery-rails", "~> 4.0", ">= 4.0.5"
  s.add_dependency "bootstrap-sass", "~> 3.3", ">= 3.3.5"
  s.add_dependency "sass-rails", "~> 5.0", ">= 5.0.4"
  s.add_dependency "bootstrap_form", "~> 2.3", ">= 2.3.0"
  s.add_dependency 'turbolinks'
  s.add_dependency 'autoprefixer-rails'
  s.add_dependency 'acts_as_list', '0.7.2'
  s.add_dependency 'closure_tree', '~> 6.2'
  s.add_dependency 'translit', '~> 0.1.5'
  s.add_dependency 'has_permalink', '~> 0.1.7'
  s.add_dependency 'bootstrap-wysihtml5-rails', '~> 0.3.3.8'
  s.add_dependency 'carrierwave', '~> 1.0'
  s.add_dependency 'lightbox2-rails', '~> 2.8', '>= 2.8.2.1'
  s.add_dependency 'image-picker-rails', '~> 0.2.4'
  s.add_dependency 'bootstrap-switch-rails', '~> 3.3', '>= 3.3.3'
  s.add_dependency 'momentjs-rails', '~> 2.15', '>= 2.15.1'
  s.add_dependency 'bootstrap3-datetimepicker-rails', '~> 4.17', '>= 4.17.43'
  s.add_dependency 'bootbox-rails', '~> 0.5.0'
  s.add_dependency 'font-awesome-rails', '~> 4.7', '>= 4.7.0.1'
  s.add_dependency 'devise', '3.5.1'
  s.add_dependency 'validates_email_format_of', '~> 1.6', '>= 1.6.3'
  s.add_dependency 'rails-settings-cached', '~> 0.6.5'
  s.add_dependency 'will_paginate', '~> 3.0.6'
  s.add_dependency 'will_paginate-bootstrap', '~> 1.0', '>= 1.0.1'
  s.add_dependency 'rspec-instrumentation-matcher', '~> 0.0.4'
  s.add_dependency 'faker', '~> 1.7', '>= 1.7.2'
  s.add_dependency 'scoped_search', '~> 4.0'
  s.add_dependency 'prawn', '~> 2.1'
  s.add_dependency 'prawn-table', '~> 0.2.2'
  s.add_dependency 'ru_propisju', '~> 2.5'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3.3.3"
  s.add_development_dependency "factory_girl_rails", "~> 4.5.0"
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'rack_session_access'
  s.add_development_dependency "hirb", "~> 0.7.3"
  s.add_development_dependency "letter_opener"

  s.add_development_dependency 'better_errors', '~> 2.1', '>= 2.1.1'
  s.add_development_dependency 'binding_of_caller', '~> 0.7.2'
  s.add_development_dependency 'annotate'
end
