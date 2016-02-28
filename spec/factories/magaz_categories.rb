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

require 'faker'

FactoryGirl.define do
  factory :magaz_category, :class => 'Magaz::Category' do
    code { Faker::Number.number(5) }
    name { Faker::Commerce.department }
    description { Faker::Lorem.paragraph }
    hidden false

    factory :magaz_category_with_products do
      transient do
        product_count 10
      end
      after(:create) do |category, evaluator|
        create_list(:magaz_product, evaluator.product_count, category: category)
      end
    end

    factory :magaz_category_with_children do
      transient do
        children_count 3
      end

      after(:create) do |category, evaluator|
        1.upto(evaluator.children_count) { category.children << create(:magaz_category) }
      end
    end

    factory :magaz_category_with_properties_and_products do

      transient do
        group_count 2
        product_count 10
      end
      
      after(:create) do |category, evaluator|
        1.upto(evaluator.group_count) { category.property_groups << create(:magaz_property_group_with_properties) }
        create_list(:magaz_product_with_variants, evaluator.product_count, category: category).each do |product|
          Magaz::Property.all.each do |property|
            product.property_values.create(property_id: property.id, value: Faker::Lorem.word)
            product.variants.each do |variant|
              variant.property_values.create(property_id: property.id, value: Faker::Lorem.word)
            end
          end
        end
      end
    end
  end

end
