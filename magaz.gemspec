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
  s.add_dependency 'acts_as_list', '~> 0.7.2'
  s.add_dependency 'closure_tree'
  s.add_dependency 'translit'
  s.add_dependency 'has_permalink'
  s.add_dependency 'bootstrap-wysihtml5-rails'
  s.add_dependency 'carrierwave'
  s.add_dependency 'lightbox2-rails'
  s.add_dependency 'image-picker-rails'
  s.add_dependency 'bootstrap-switch-rails'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "~> 3.3.3"
  s.add_development_dependency "factory_girl_rails", "~> 4.5.0"
  s.add_development_dependency 'faker'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'rack_session_access'
  s.add_development_dependency "hirb", "~> 0.7.3"

  s.add_development_dependency 'better_errors', '~> 2.1', '>= 2.1.1'
  s.add_development_dependency 'binding_of_caller', '~> 0.7.2'
  s.add_development_dependency 'annotate'
end
