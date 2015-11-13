# == Schema Information
#
# Table name: magaz_property_values
#
#  id            :integer          not null, primary key
#  property_id   :integer
#  value         :string
#  valuable_id   :integer
#  valuable_type :string
#  position      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe PropertyValue, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
