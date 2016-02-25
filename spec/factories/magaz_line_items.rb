# == Schema Information
#
# Table name: magaz_line_items
#
#  id          :integer          not null, primary key
#  product_id  :integer
#  variant_id  :integer
#  price       :decimal(8, 2)
#  count       :integer
#  total_count :decimal(8, 3)
#  manual      :boolean          default(FALSE)
#  ratio       :decimal(8, 3)
#  cart_id     :integer
#  order_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :magaz_line_item, :class => 'Magaz::LineItem' do

    
    count { Faker::Number.between(1, 100) }
   
    association :product, factory: :magaz_product

    trait :with_variant do
      association :variant, factory: :magaz_variant
    end

    trait :with_variant_nil_price do
      association :variant, factory: :magaz_variant, price: nil
    end

    trait :manual_and_total_count do
      manual true
      total_count { Faker::Number.between(1, 100) }
    end

    trait :ratio do
      ratio { Faker::Number.decimal(2) }
    end

    trait :price do
      price { Faker::Commerce.price }
    end

    factory :magaz_line_item_with_variant, traits: [:with_variant]
    factory :magaz_line_item_with_variant_nil_price, traits: [:with_variant_nil_price]
    factory :magaz_line_item_with_ratio, traits: [:ratio]
    factory :magaz_line_item_with_total_count, traits: [:manual_and_total_count, :ratio]
    factory :magaz_line_item_with_price, traits: [:price]

    transient do
      moulded false
    end

    after(:create) do |line_item, evaluator|
      line_item.product.moulded = evaluator.moulded
    end

  end
end
