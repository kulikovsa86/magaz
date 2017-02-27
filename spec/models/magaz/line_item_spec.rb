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

require 'rails_helper'

module Magaz
  RSpec.describe LineItem, type: :model do
    before :each do
      @li = create(:magaz_line_item)
    end

    it "has a valid factory" do
      expect(@li).to be_valid
    end

    context "item price in cart" do
      it "returns product price" do
        li = create(:magaz_line_item)
        expect(li.cart_price).to eq(li.product.price)
      end

      it "returns variant price" do
        li = create(:magaz_line_item_with_variant)
        expect(li.cart_price).to eq(li.variant.price)
      end

      it "returns product price if variant has nil price" do
        li = create(:magaz_line_item_with_variant_nil_price)
        expect(li.cart_price).to eq(li.product.price)
      end
    end

    context "units count" do
      it "returns item count" do
        li = create(:magaz_line_item)
        expect(li.unit_count).to eq(li.count)
      end

      it "returns item count * ratio" do
        li = create(:magaz_line_item_with_ratio)
        expect(li.unit_count).to eq(li.count * li.ratio)
      end

      it "returns total_count" do
        li = create(:magaz_line_item_with_total_count)
        expect(li.unit_count).to eq(li.total_count)
      end
    end

    context "item amount" do
      it "returns count for non-moulded product" do
        li = create(:magaz_line_item)
        expect(li.amount).to eq(li.count)
      end

      it "returns unit_count for moulded product" do
        li = create(:magaz_line_item_with_ratio, moulded: true)
        expect(li.amount).to eq(li.unit_count)
      end
    end

    context "total price" do
      it "returns total_price for product" do
        li = create(:magaz_line_item)
        expect(li.total_cart_price).to eq(li.product.price * li.amount)
      end

      it "returns total_price for lineitem" do
        li = create(:magaz_line_item_with_price)
        expect(li.total_order_price).to eq(li.price * li.amount)
      end
    end

  end
end
