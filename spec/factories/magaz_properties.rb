# == Schema Information
#
# Table name: magaz_properties
#
#  id                :integer          not null, primary key
#  code              :string
#  name              :string
#  description       :text
#  property_type_id  :integer
#  static            :boolean          default(FALSE)
#  variant           :boolean          default(FALSE)
#  position          :integer
#  property_group_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :magaz_property, :class => 'Magaz::Property' do
    code { Faker::Number.number(5) }
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    association :property_type, factory: :magaz_property_type
    association :property_group, factory: :magaz_property_group
    static false
    variant false
  end

end
