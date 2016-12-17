# == Schema Information
#
# Table name: magaz_products
#
#  id           :integer          not null, primary key
#  name         :string
#  var_name     :string
#  category_id  :integer
#  description  :text
#  price        :decimal(8, 2)
#  hidden       :boolean          default(TRUE)
#  article      :string
#  weight       :decimal(6, 3)
#  position     :integer
#  permalink    :string
#  input_dim_id :integer
#  calc_dim_id  :integer
#  correct      :boolean          default(FALSE)
#  moulded      :boolean          default(FALSE)
#  stock        :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe Product, type: :model do

    before :each do
      @product = create(:magaz_product)
    end

    it "has a valid factory" do
      expect(@product).to be_valid
    end

    it "is not valid with empty attributes" do
      product = Product.new
      expect(product.valid?).to be(false)
      expect(product.errors[:name].any?).to be(true)
      expect(product.errors[:category].any?).to be(true)
    end

    it "has not a uniquie title" do
      expect(build(:magaz_product, name: @product.name).valid?).to be(true)
    end

    it "sets properties" do
      count = 10
      create_list(:magaz_property, count)
      properties = Property.all.map{ |p| Hash[:property_id, "#{p.id}", :value, Faker::Lorem.word] }
      @product.set_properties(properties)
      expect(PropertyValue.count).to eq(count)
      expect(@product.property_values.size).to eq(count)
    end

    it "gets value" do
      p = create(:magaz_product_with_properties)
      PropertyValue.all.each do |pvalue|
        expect(p.value(pvalue.property_id)).to eq(pvalue.value)
      end
      expect(p.value('')).to eq('')
    end

    it "can shift" do
      total_count = 10
      checked_count = 6
      category_from = create(:magaz_category_with_products, product_count: total_count)
      items = category_from.products.map{ |p| Hash[:id, p.id, :checked, false] }
      0.upto(checked_count - 1) { |i| items[i][:checked] = true }
      category_to = create(:magaz_category)
      params = {target: category_to.id, items: items}
      Product.shift(params, false)
      category_from.reload
      expect(category_from.products.size).to eq(total_count - checked_count)
      expect(category_to.products.size).to eq(checked_count)
    end

  end
end
