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
#  liable_id   :integer
#  liable_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  note        :string
#

module Magaz
  class LineItem < ActiveRecord::Base

    belongs_to :product
    belongs_to :variant
    belongs_to :liable, polymorphic: true

    def calc_dim_name
      if product && product.moulded
        product.calc_dim.name
      else
        Magaz::Dimension.default.name
      end
    end

    def cart_price
      if variant && variant.price
        variant.price
      else
        product.price
      end
    end

    def cart_price!
      self.price = cart_price
      save
    end

    def total_cart_price
      if cart_price
        cart_price * amount
      else
        0
      end
    end

    def total_order_price
      if price && count
        price * amount
      else
        0
      end
    end

    def unit_count
      if manual?
        total_count
      elsif ratio
        count * ratio
      else
        count
      end
    end

    def amount
      unless product.moulded
        count
      else
        unit_count
      end
    end

    def manual?
      if manual && total_count
        true
      else
        false
      end
    end

    def manual_tag
      if manual?
        '*'
      else
        ''
      end
    end

  end
end
