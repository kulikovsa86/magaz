# == Schema Information
#
# Table name: magaz_variants
#
#  id         :integer          not null, primary key
#  product_id :integer
#  price      :decimal(8, 2)
#  name       :string
#  hidden     :boolean          default(FALSE)
#  position   :integer
#  stock      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  permalink  :string
#

require 'rails_helper'

module Magaz
  RSpec.describe Variant, type: :model do
    
    before :each do
      @variant = create(:magaz_variant)
    end

    it "has a valid factory" do
      expect(@variant).to be_valid
    end

    it "sets properties" do
      count = 10
      create_list(:magaz_property, count)
      properties = Property.all.map{ |p| Hash[:property_id, "#{p.id}", :value, Faker::Lorem.word] }
      @variant.set_properties(properties)
      expect(PropertyValue.all.size).to eq(count)
      expect(@variant.property_values.size).to eq(count)
    end

    it "can shift" do
      total_count = 10
      checked_count = 6
      product = create(:magaz_product_with_variants, variant_count: total_count)
      items = product.variants.map{ |v| Hash[:id, v.id, :checked, false] }
      0.upto(checked_count - 1) { |i| items[i][:checked] = true }
      Variant.shift({items: items}, true)
      product.reload
      expect(product.variants.size).to eq(total_count - checked_count)
    end

  end
end
