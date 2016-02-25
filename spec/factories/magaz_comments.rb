# == Schema Information
#
# Table name: magaz_comments
#
#  id         :integer          not null, primary key
#  name       :string
#  text       :text
#  rate       :integer
#  accepted   :boolean          default(FALSE)
#  fresh      :boolean          default(TRUE)
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :magaz_comment, :class => 'Magaz::Comment' do
    name { Faker::Name.name }
    text { Faker::Lorem.paragraph }
    rate { Faker::Number.between(1, 5) }
    accepted false
    association :product, factory: :magaz_product
  end
end
