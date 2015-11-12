# == Schema Information
#
# Table name: magaz_variant_images
#
#  id         :integer          not null, primary key
#  variant_id :integer
#  image_id   :integer
#

module Magaz
  class VariantImage < ActiveRecord::Base
    belongs_to :variant
    belongs_to :image
  end
end
