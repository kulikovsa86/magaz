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
  end

end
