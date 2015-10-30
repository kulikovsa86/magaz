module Magaz
  module PropertiesHelper
    def new_property_page?
      current_page?(new_property_path)
    end
  end
end
