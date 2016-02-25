# == Schema Information
#
# Table name: magaz_categories
#
#  id          :integer          not null, primary key
#  code        :string
#  name        :string
#  description :string
#  hidden      :boolean          default(TRUE)
#  parent_id   :integer
#  position    :integer
#  permalink   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe Category, type: :model do
    
    before :each do
      @category = create(:magaz_category)
      @category_with_products = create(:magaz_category_with_products)
      @category_pp = create(:magaz_category_with_properties_and_products)
    end

    it "has valid factories" do
      expect(@category).to be_valid
      expect(@category_with_products).to be_valid
      expect(@category_pp).to be_valid
    end

    it "cleans descendant properties" do
      property_values_total_count = 600
      expect(PropertyValue.all.reload.size).to eq(property_values_total_count)
      property_group = @category_pp.property_groups.first
      @category_pp.property_groups.delete(property_group)
      @category_pp.save
      expect(PropertyValue.all.reload.size).to eq(property_values_total_count / 2)
      property_group.properties.each do |property|
        expect(PropertyValue.where(property_id: property.id).size).to eq(0)
      end
    end

  end
end
