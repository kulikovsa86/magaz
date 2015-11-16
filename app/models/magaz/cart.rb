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

    # params = {product_id: "id", variant_id: "id"}
    def has_item?(params)
      @line_item = items.find_by(product_id: params[:product_id], variant_id: params[:variant_id])
    end

    # params = {product_id: "id", variant_id: "id", count: "id"}
    def add_item(params) 
      unless has_item?(params)
        @line_item = items.create(product_id: params[:product_id], variant_id: params[:variant_id], count: params[:count])
      else
        @line_item
      end
    end

    def delete_item(item_id)
      items.delete(LineItem.find(item_id))
    end

    def empty?
      items.empty?
    end

    # params = [{id: "id", count: "count"}, ...]
    def recount(params)
      if params
        params.each do |param_item|
          item = items.find(param_item[:id])
          item.update(count: param_item[:count]) if item
        end
      end
    end
  end
end
