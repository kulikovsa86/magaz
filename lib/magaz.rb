require 'haml-rails'
require 'jquery-rails'
require 'bootstrap-sass'
require 'bootstrap_form'
require 'sass-rails'
require 'turbolinks'
require 'autoprefixer-rails'
require 'acts_as_list'
require 'closure_tree'
require 'translit'
require 'has_permalink'
require 'bootstrap-wysihtml5-rails'
require 'carrierwave'
require 'lightbox2-rails'
require 'image-picker-rails'
require 'bootstrap-switch-rails'
require 'momentjs-rails'
require 'bootstrap3-datetimepicker-rails'
require 'bootbox-rails'
require 'font-awesome-rails'
require 'devise'
require 'validates_email_format_of'
require 'rails-settings-cached'
require 'will_paginate'
require 'will_paginate-bootstrap'
require 'rspec-instrumentation-matcher'

require "magaz/engine"

module Magaz
  def self.root
    File.expand_path('../../', __FILE__)
  end
  def self.image_dir
    File.join(Magaz.root, "app/assets/images/magaz/")
  end
end
