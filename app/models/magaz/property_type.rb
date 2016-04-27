# == Schema Information
#
# Table name: magaz_property_types
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Magaz
  class PropertyType < ActiveRecord::Base
    belongs_to :property

    validates :code, :name, presence: true
    validates :code, allow_blank: true, uniqueness: true

    LIST_CODE = '01'
    NUMBER_CODE = '02'
    FLOAT_CODE = '021'
    STRING_CODE = '03'
    TEXT_CODE = '04'
    BOOL_CODE = '05'
    COLOR_CODE = '10'

    def self.list
      PropertyType.find_by(code: PropertyType::LIST_CODE)
    end

    def self.number
      PropertyType.find_by(code: PropertyType::NUMBER_CODE)
    end

  end
end
