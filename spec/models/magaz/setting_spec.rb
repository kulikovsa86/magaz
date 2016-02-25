# == Schema Information
#
# Table name: magaz_settings
#
#  id         :integer          not null, primary key
#  name       :string
#  value      :string
#  param      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe Setting, type: :model do
    
    before :each do
      @setting = create(:magaz_setting)
      @name = Faker::Lorem.word
      @value = Faker::Lorem.word
    end

    it "has a valid factory" do
      expect(@setting).to be_valid
    end

    it "sets a new value" do
      Setting.set(@name, @value)
      setting = Setting.find_by(name: @name)
      expect(setting).to_not be_nil
      expect(setting.value).to eq(@value)
    end

    it "gets existing value" do
      s = create(:magaz_setting, name: @name, value: @value)
      expect(Setting.get(@name)).to eq(@value)
    end

    context "sets bool value" do

      it "false" do
        [nil, false, '0'].each do |val|
          Setting.delete_all
          Setting.set_bool(@name, val)
          setting = Setting.find_by(name: @name)
          expect(setting).to_not be_nil
          expect(setting.value).to eq('0')
        end
      end

      it "true" do
        [Random.rand(100), true, Faker::Lorem.word, '1'].each do |val|
          Setting.delete_all
          Setting.set_bool(@name, val)
          setting = Setting.find_by(name: @name)
          expect(setting).to_not be_nil
          expect(setting.value).to eq('1')
        end
      end
      
    end

    context "gets bool" do

      it "false" do
        ['0', nil].each do |val|
          setting = create(:magaz_setting, value: val)
          expect(Setting.get_bool(setting.name)).to be false
        end
      end

      it "true" do
        [true, '1', Random.rand(100), Faker::Lorem.word].each do |val|
          setting = create(:magaz_setting, value: val)
          expect(Setting.get_bool(setting.name)).to be true
        end
      end

    end

  end
end
