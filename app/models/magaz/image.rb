# == Schema Information
#
# Table name: magaz_images
#
#  id             :integer          not null, primary key
#  picture        :string
#  imageable_id   :integer
#  imageable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'carrierwave/orm/activerecord'

module Magaz
  class Image < ActiveRecord::Base
    belongs_to :imageable, polymorphic: true

    mount_uploader :picture, PictureUploader
  end
end
