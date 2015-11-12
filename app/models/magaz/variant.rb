# == Schema Information
#
# Table name: magaz_variants
#
#  id         :integer          not null, primary key
#  product_id :integer
#  price      :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Magaz
  class Variant < ActiveRecord::Base
    belongs_to :product
    has_many :property_values, dependent: :destroy
    has_many :variant_images, dependent: :destroy
    has_many :images, through: :variant_images

    # properties = [{property_id: "", value: ""}, ...]
    def set_properties(properties)
      properties.each do |pv|
        property_values.create(property_id: pv[:property_id], value: pv[:value])
      end
    end

    def values_string
      values = []
      property_values.each do |pv|
        if pv.property && pv.property.type.code != '10'
          values << pv.value
        end
      end
      values.join(', ')
    end

    def colors_string
      colors = ''
      property_values.each do |pv|
        if pv.property && pv.property.type.code == '10'
          colors << "<div class='small-colored-square' style='background-color:##{pv.value};'></div>"
        end
      end
      colors
    end

  end
end
