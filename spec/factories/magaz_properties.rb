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

require 'faker'

FactoryGirl.define do
  factory :magaz_property, :class => 'Magaz::Property' do

    code { Faker::Lorem.characters(5)  }
    name { Faker::Lorem.sentence  }
    property_type nil
    static false
    
  end
end
