# == Schema Information
#
# Table name: magaz_properties
#
#  id                :integer          not null, primary key
#  code              :string
#  name              :string
#  description       :text
#  property_type_id  :integer
#  static            :boolean          default(FALSE)
#  variant           :boolean          default(FALSE)
#  position          :integer
#  property_group_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  property_kind_id  :integer
#

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
