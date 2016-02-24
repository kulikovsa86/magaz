# == Schema Information
#
# Table name: magaz_property_groups
#
#  id         :integer          not null, primary key
#  name       :string
#  code       :string
#  parent_id  :integer
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe PropertyGroup, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
