# == Schema Information
#
# Table name: magaz_products
#
#  id           :integer          not null, primary key
#  name         :string
#  var_name     :string
#  category_id  :integer
#  description  :text
#  price        :decimal(8, 2)
#  hidden       :boolean          default(TRUE)
#  article      :string
#  weight       :decimal(6, 3)
#  position     :integer
#  permalink    :string
#  input_dim_id :integer
#  calc_dim_id  :integer
#  correct      :boolean          default(FALSE)
#  moulded      :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :magaz_product, :class => 'Magaz::Product' do
    name { "#{Faker::Commerce.product_name} #{Random.rand(1000)}" }
    association :category, factory: :magaz_category
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price }
    article { Faker::Lorem.word }
    association :input_dim, factory: :magaz_dimension
    association :calc_dim, factory: :magaz_dimension
    correct false
    moulded false

    factory :magaz_product_with_properties do
      transient do
        property_count 10
      end
      after(:create) do |product, evaluator|
        create_list(:magaz_property, evaluator.property_count).each do |prop|
          product.property_values.create(property_id: prop.id, value: Faker::Lorem.word)
        end
      end
    end

    factory :magaz_product_with_variants do
      transient do
        variant_count 5
      end

      after(:create) do |product, evaluator|
        create_list(:magaz_variant, evaluator.variant_count, product: product)
      end
    end

    factory :magaz_product_with_comments do
      transient do
        comment_count 5
      end

      after(:create) do |product, evaluator|
        create_list(:magaz_comment, evaluator.comment_count, product: product)
      end
    end
  end
end
