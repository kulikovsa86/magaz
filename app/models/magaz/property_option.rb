# == Schema Information
#
# Table name: magaz_property_options
#
#  id          :integer          not null, primary key
#  property_id :integer
#  code        :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position    :integer
#

module Magaz
  class PropertyOption < ActiveRecord::Base
    acts_as_list scope: :property
  end
end
