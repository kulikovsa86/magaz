require 'rails_helper'

module ControllerHelpers
  def attributes_with_foreign_keys_for(*args)
    build(*args).attributes.delete_if do |k, v|
      ["id", "created_at", "updated_at"].member?(k)
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :view
  config.include ControllerHelpers, type: :controller
end