# == Schema Information
#
# Table name: magaz_variant_images
#
#  id         :integer          not null, primary key
#  variant_id :integer
#  image_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Magaz
  class VariantImage < ActiveRecord::Base
    belongs_to :variant
    belongs_to :image
  end
end
