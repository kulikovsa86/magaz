# == Schema Information
#
# Table name: magaz_carts
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe Cart, type: :model do

    let(:item_count) { Random.rand(10) + 1 }

    it "has a valid factory" do
      expect(create(:magaz_cart)).to be_valid
    end

    it "finds item with product and variant id" do
      cart = create(:magaz_cart_with_items, item_count: item_count, with_variant: true)
      expect(cart.items.size).to eq(item_count)
      item = cart.items[Random.rand(item_count)]
      expect(cart.has_item?(product_id: item.product.id, variant_id: item.variant.id)).to eq(item)
    end

    context "adds item to cart" do
      it "creates new item" do
        cart = create(:magaz_cart)
        product = create(:magaz_product)
        variant = create(:magaz_variant)
        params = {product_id: product.id, variant_id: variant.id, count: Random.rand(10) + 1}
        expect(cart.add_item(params)).to be_a(LineItem)
      end

      it "do nothing if item exists" do
        cart = create(:magaz_cart_with_items, item_count: item_count, with_variant: true)
        item = cart.items[Random.rand(item_count)]
        params = {product_id: item.product.id, variant_id: item.variant.id, count: Random.rand(10) + 1}
        expect(cart.add_item(params)).to eq(item)
      end
    end

    it "deletes item from cart" do
      cart = create(:magaz_cart_with_items, item_count: item_count, with_variant: true)
      item = cart.items[Random.rand(item_count)]
      expect {
        cart.delete_item(item.id)
      }.to change{ cart.items.size }.by(-1)
    end

    it "recount items in cart" do
      cart = create(:magaz_cart_with_items, item_count: item_count)
      new_count = Faker::Number.between(101, 200)
      params = cart.items.map{ |i| Hash[:id, i.id, :count, new_count] }
      cart.recount(params)
      cart.reload.items.each do |item|
        expect(item.count).to eq(new_count)
      end
    end

  end
end
