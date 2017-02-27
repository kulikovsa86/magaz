# == Schema Information
#
# Table name: magaz_orders
#
#  id               :integer          not null, primary key
#  customer         :string
#  company          :string
#  phone            :string
#  email            :string
#  delivery_id      :integer
#  address1         :string
#  address2         :string
#  address3         :string
#  address4         :string
#  post_code        :string
#  payment_id       :integer
#  status_id        :integer
#  pdt              :datetime
#  customer_comment :text
#  manager_comment  :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  offer            :boolean
#  offer_sent       :datetime
#  payer            :text
#  consignee        :text
#

require 'faker'

FactoryGirl.define do
  factory :magaz_order, :class => 'Magaz::Order' do
    customer { Faker::Name.name }
    phone { Faker::PhoneNumber.cell_phone }
    email { Faker::Internet.free_email(Faker::Name.first_name) }

    association :delivery, factory: :magaz_delivery
    association :payment, factory: :magaz_payment

    trait :company do
      company { Faker::Company.name }
    end

    trait :address do
      association :delivery, factory: :magaz_delivery_with_address
    end

    trait :address_and_post_code do
      association :delivery, factory: :magaz_delivery_with_address_and_post_code
    end

    factory :magaz_order_with_company, traits: [:company]
    factory :magaz_order_with_address, traits: [:address]
    factory :magaz_order_with_address_and_post_code, traits: [:address_and_post_code]

    factory :magaz_order_with_items do
      transient do
        item_count 5
      end

      after(:create) do |order, evaluator| 
        create_list(:magaz_line_item, evaluator.item_count, liable: order, price: 1, count: 1)
      end
    end

    factory :magaz_order_with_manual_line_items do
      transient do
        item_count 5
      end

      after(:create) do |order, evaluator|
        create_list(:magaz_line_item_with_total_count, evaluator.item_count, liable: order)
      end
    end

  end
end
