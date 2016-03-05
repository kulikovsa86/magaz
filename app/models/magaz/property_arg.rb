# == Schema Information
#
# Table name: magaz_property_args
#
#  id          :integer          not null, primary key
#  property_id :integer
#  min         :decimal(, )
#  max         :decimal(, )
#  step        :decimal(, )
#  default     :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module Magaz
  class PropertyArg < ActiveRecord::Base
    belongs_to :property

    def rand
      if !min || !max
        Random.rand(100)
      else
        (min.to_i..max.to_i).to_a.sample
      end
    end
  end
end
