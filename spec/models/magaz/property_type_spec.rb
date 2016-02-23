# == Schema Information
#
# Table name: magaz_property_types
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe PropertyType, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
