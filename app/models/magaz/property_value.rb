# == Schema Information
#
# Table name: magaz_property_values
#
#  id          :integer          not null, primary key
#  variant_id  :integer
#  property_id :integer
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module Magaz
  class PropertyValue < ActiveRecord::Base
    belongs_to :variant
    belongs_to :property
  end
end
