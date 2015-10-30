# == Schema Information
#
# Table name: magaz_properties
#
#  id               :integer          not null, primary key
#  code             :string
#  name             :string
#  property_type_id :integer
#  static           :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe Property, type: :model do

    before :each do
      @prop = create(:magaz_property)
    end

    it "has a valid factory" do
      expect(@prop).to be_valid
    end

    it "is not valid with empty attributes" do
      prop = Property.new
      expect(prop.valid?).to be false
      expect(prop.errors[:code].any?).to be true
      expect(prop.errors[:name].any?).to be true
    end

    it "has a unique code" do
      expect(build(:magaz_property, code: @prop.code).valid?).to be false
    end
    
  end
end
