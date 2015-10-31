# == Schema Information
#
# Table name: magaz_property_values
#
#  id          :integer          not null, primary key
#  variant_id  :integer
#  property_id :integer
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe PropertyValue, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
