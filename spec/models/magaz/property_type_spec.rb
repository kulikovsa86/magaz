# == Schema Information
#
# Table name: magaz_property_types
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe PropertyType, type: :model do

    before :each do
      @type = create(:magaz_property_type)
    end

    it "has a valid factory" do
      expect(@type).to be_valid
    end

    it "is not valid with empty attributes" do
      type = PropertyType.new
      expect(type.valid?).to be false
      expect(type.errors[:code].any?).to be true
      expect(type.errors[:name].any?).to be true
    end

    it "has a unique code" do
      expect(build(:magaz_property_type, code: @type.code).valid?).to be false
    end

  end
end
