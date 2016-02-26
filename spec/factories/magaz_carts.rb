# == Schema Information
#
# Table name: magaz_carts
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :magaz_cart, :class => 'Magaz::Cart' do
    
    factory :magaz_cart_with_items do
      transient do
        item_count 10
        with_variant false
      end

      after(:create) do |cart, evaluator|
        unless evaluator.with_variant
          create_list(:magaz_line_item, evaluator.item_count, cart: cart)
        else
          create_list(:magaz_line_item_with_variant, evaluator.item_count, cart: cart)
        end
      end
    end


  end
end
