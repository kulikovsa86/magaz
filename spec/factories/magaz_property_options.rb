# == Schema Information
#
# Table name: magaz_property_options
#
#  id          :integer          not null, primary key
#  property_id :integer
#  code        :string
#  name        :string
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :magaz_property_option, :class => 'Magaz::PropertyOption' do
    association :property, factory: :magaz_property
    code { Faker::Number.number(5) }
    name { Faker::Lorem.sentence }
  end
end
