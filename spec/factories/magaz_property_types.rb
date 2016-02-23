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

require 'faker'

FactoryGirl.define do
  factory :magaz_property_type, :class => 'Magaz::PropertyType' do    
    code { Faker::Number.number(5) }
    name { Faker::Lorem.sentence }
  end
end
