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

module Magaz
  class LineItem < ActiveRecord::Base
    belongs_to :product
    belongs_to :variant
    belongs_to :cart
  end
end
