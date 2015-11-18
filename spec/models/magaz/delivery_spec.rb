# == Schema Information
#
# Table name: magaz_deliveries
#
#  id                 :integer          not null, primary key
#  code               :string
#  name               :string
#  note               :text
#  address_required   :boolean
#  post_code_required :boolean
#  price              :decimal(8, 2)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe Delivery, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
