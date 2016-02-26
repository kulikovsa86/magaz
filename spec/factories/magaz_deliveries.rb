# == Schema Information
#
# Table name: magaz_deliveries
#
#  id                 :integer          not null, primary key
#  code               :string
#  name               :string
#  note               :text
#  address_required   :boolean
#  post_code_required :boolean
#  price              :decimal(8, 2)
#  position           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :magaz_delivery, :class => 'Magaz::Delivery' do
    code { Faker::Number.number(5) }
    name { Faker::Lorem.sentence }
    note { Faker::Lorem.paragraph }
    address_required false
    post_code_required false

    trait :address do
      address_required true
    end

    trait :post_code do
      post_code_required true
    end

    factory :magaz_delivery_with_address, traits: [:address]
    factory :magaz_delivery_with_address_and_post_code, traits: [:address, :post_code]

  end
end
