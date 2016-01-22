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

require 'rails_helper'

module Magaz
  RSpec.describe PropertyArg, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
