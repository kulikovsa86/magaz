# == Schema Information
#
# Table name: magaz_property_groups
#
#  id         :integer          not null, primary key
#  name       :string
#  code       :string
#  parent_id  :integer
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :magaz_property_group, :class => 'Magaz::PropertyGroup' do
    code { Faker::Number.number(5) }
    name { Faker::Lorem.sentence }

    factory :magaz_property_group_with_properties do
      transient do
        property_count 5
      end

      after(:create) do |property_group, evaluator| 
        create_list(:magaz_property, evaluator.property_count, property_group: property_group)
      end
    end

    factory :magaz_property_group_with_groups do
      transient do
        group_count 5
      end

      after(:create) do |property_group, evaluator|
        create_list(:magaz_property_group, evaluator.group_count).each do |group|
          property_group.children << group
        end
      end
    end
  end

end
