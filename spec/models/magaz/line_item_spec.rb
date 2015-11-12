# == Schema Information
#
# Table name: magaz_line_items
#
#  id         :integer          not null, primary key
#  product_id :integer
#  variant_id :integer
#  price      :decimal(8, 2)
#  count      :integer
#  cart_id    :integer
#  order_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe LineItem, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
