# == Schema Information
#
# Table name: magaz_carts
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Magaz
  class Cart < ActiveRecord::Base
    has_many :line_items, dependent: :destroy

    def items
      line_items
    end

    def has_item?(params)
      @line_item = items.find_by(product_id: params[:product_id], variant_id: params[:variant_id])
    end

    def add_item(params) 
      unless has_item?(params)
        @line_item = items.create(product_id: params[:product_id], variant_id: params[:variant_id], count: params[:count])
      else
        @line_item
      end
    end
  end
end
