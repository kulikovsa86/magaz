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
  end
end
