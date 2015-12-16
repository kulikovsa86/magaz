module Magaz
  module PropertiesHelper
    def new_property_page?
      if @parent_group && current_page?(new_property_group_property_path(@parent_group))
        true
      else
        false
      end
    end
  end
end
