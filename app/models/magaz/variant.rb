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

    def to_s
      colors = ''
      s = []
      property_values.each do |pv|
        if pv.property.type.code == '10'
          colors << "<div class='small-colored-square' style='background-color:##{pv.value};'></div>"
        else
          s << pv.value
        end
      end
      colors + s.join(', ')
    end
  end
end
