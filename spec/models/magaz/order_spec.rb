# == Schema Information
#
# Table name: magaz_orders
#
#  id               :integer          not null, primary key
#  customer         :string
#  company          :string
#  phone            :string
#  email            :string
#  delivery_id      :integer
#  address1         :string
#  address2         :string
#  address3         :string
#  address4         :string
#  post_code        :string
#  payment_id       :integer
#  status_id        :integer
#  pdt              :datetime
#  customer_comment :text
#  manager_comment  :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe Order, type: :model do
    
    it "has a valid factory" do
      expect(create(:magaz_order)).to be_valid
    end

    context "order status" do
      before :each do
        @status = create(:magaz_status, code: '01')
        @order = create(:magaz_order)
      end

      it "saves new order with default status (01)" do
        expect(@order.status).to eq(@status)
      end

      it "logs status if status changed" do
        new_status = create(:magaz_status, code: '02')
        expect {
          @order.update(status_id: new_status.id)
        }.to change{ OrderStatus.all.size }.by(1)
      end
    end

    context "company validation" do
      it "doesn't validate company by default" do
        order = create(:magaz_order)
        expect(order.valid?).to be true
      end

      it "is not valid with empty company" do
        order = create(:magaz_order)
        order.company_valid = true
        expect(order.valid?).to be(false)
        expect(order.errors[:company].any?).to be(true)
      end

      it "is valid with company" do
        order = create(:magaz_order_with_company)
        order.company_valid = true
        expect(order.valid?).to be(true)
      end
    end

    context "delivery" do
      it "validates delivery by default" do
        order = Order.new
        expect(order.valid?).to be(false)
        expect(order.errors[:delivery].any?).to be(true)
      end

      it "doesn't validate if set skip accessor" do
        order = Order.new
        order.skip_delivery_valid = true
        expect(order.valid?).to be(false)
        expect(order.errors[:delivery].any?).to be(false)
      end

      it "validates adderess lines if delivery require address" do
        order = build(:magaz_order_with_address)
        expect(order.valid?).to be(false)
        expect(order.errors[:address1].any?).to be(true)
        expect(order.errors[:address2].any?).to be(true)
        expect(order.errors[:address3].any?).to be(true)
        expect(order.errors[:address4].any?).to be(true)
      end

      it "validates post code" do
        order = build(:magaz_order_with_address_and_post_code)
        expect(order.valid?).to be(false)
        expect(order.errors[:post_code].any?).to be(true)
      end
    end

    context "payment" do
      it "validates payment be default" do
        order = Order.new
        expect(order.valid?).to be(false)
        expect(order.errors[:payment].any?).to be(true)
      end

      it "doesn't validate if set skip accessor" do
        order = Order.new
        order.skip_payment_valid = true
        expect(order.valid?).to be(false)
        expect(order.errors[:payment].any?).to be(false)
      end
    end

    context "pdt" do
      it "doesn't validate by default" do
        order = Order.new
        expect(order.valid?).to be(false)
        expect(order.errors[:pdt].any?).to be(false)
      end

      it "validates if accessor was set" do
        order = Order.new
        order.pdt_valid = true
        expect(order.valid?).to be(false)
        expect(order.errors[:pdt].any?).to be(true)
      end
    end

    context "order items" do
      it "calcs total count" do
        order = create(:magaz_order_with_items)
        expect(order.total_price).to eq(order.items.size)
      end

      it "determines moulded product" do
        item_count = Random.rand(10) + 1
        order = create(:magaz_order_with_items, item_count: item_count)
        expect(order.items.size).to eq(item_count)
        order.items[Random.rand(item_count)].product.update(moulded: true)
        expect(order.reload.has_moulded?).to eq(true)
      end

      it "takes all items from cart and set price" do
        item_count = Random.rand(20) + 1
        cart = create(:magaz_cart_with_items, item_count: item_count)
        order = create(:magaz_order)
        order.take_items_from_cart(cart)
        expect(cart.reload.items.size).to eq(0)
        expect(order.items.size).to eq(item_count)
        order.items.each do |item|
          expect(item.price).to eq(item.product.price)
        end
      end

      it "recount items" do
        item_count = Random.rand(20) + 1
        order = create(:magaz_order_with_items, item_count: item_count)
        item = order.items[Random.rand(item_count)]
        new_count = Faker::Number.between(101, 200)
        expect(order.recount([{id: item.id, count: new_count}])).to be(true)
        expect(item.reload.count).to eq(new_count)
      end

      it "drops total_count and manual flag in recount" do
        item_count = Random.rand(20) + 1
        order = create(:magaz_order_with_manual_line_items, item_count: item_count)
        params = order.items.map{ |i| Hash[:id, i.id, :count, Faker::Number.between(101, 200)] }
        expect(order.recount(params)).to be(true)
        order.reload.items.each do |item|
          expect(item.manual).to be(false)
          expect(item.total_count).to be_nil
        end
      end

      it "recount items unit" do
        item_count = Random.rand(20) + 1
        order = create(:magaz_order_with_items, item_count: item_count)
        item = order.items[Random.rand(item_count)]
        new_count = Faker::Number.between(101, 200)
        expect(order.recount_unit([{id: item.id, total_count: new_count}])).to be(true)
        expect(item.reload.total_count).to eq(new_count)
      end

      it "sets total_count and manual flag in recount units" do
        item_count = Random.rand(20) + 1
        order = create(:magaz_order_with_manual_line_items, item_count: item_count)
        params = order.items.map{ |i| Hash[:id, i.id, :total_count, Faker::Number.between(101, 200)] }
        expect(order.recount_unit(params)).to be(true)
        order.reload.items.each do |item|
          expect(item.manual).to be(true)
          expect(item.total_count).to_not be_nil
        end
      end
    end
    
  end
end
