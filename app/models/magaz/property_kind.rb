# == Schema Information
#
# Table name: magaz_property_kinds
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Magaz
  class PropertyKind < ActiveRecord::Base

    FEATURE_CODE = '01'
    VARIANT_CODE = '02'
    SPECIAL_CODE = '03'

    validates :name, presence: true

    FEATURE = PropertyKind.find_by(code: PropertyKind::FEATURE_CODE)
    VARIANT = PropertyKind.find_by(code: PropertyKind::VARIANT_CODE)
    SPECIAL = PropertyKind.find_by(code: PropertyKind::SPECIAL_CODE)

    def feature?
      code == FEATURE_CODE
    end

    def variant?
      code == VARIANT_CODE
    end

    def special?
      code == SPECIAL_CODE
    end
    
  end
end
