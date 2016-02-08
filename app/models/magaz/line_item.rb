# == Schema Information
#
# Table name: magaz_line_items
#
#  id          :integer          not null, primary key
#  product_id  :integer
#  variant_id  :integer
#  price       :decimal(8, 2)
#  count       :integer
#  total_count :decimal(8, 3)
#  manual      :boolean          default(FALSE)
#  ratio       :decimal(8, 3)
#  cart_id     :integer
#  order_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module Magaz
  class LineItem < ActiveRecord::Base
    belongs_to :product
    belongs_to :variant
    belongs_to :cart
    belongs_to :order

    def cart_price
      if variant && variant.price
        variant.price
      else
        product.price
      end
    end

    def total_cart_price(moulded_flag = false)
      if cart_price
        cart_price * amount(moulded_flag)
      else
        0
      end
    end

    def total_order_price(moulded_flag = false)
      if price && count
        price * amount(moulded_flag)
      else
        0
      end
    end

    def unit_count
      if total_count
        total_count
      elsif ratio
        count * ratio
      else
        count
      end
    end

    def amount(moulded_flag = false)
      unless moulded_flag
        count
      else
        unit_count
      end
    end

  end
end
