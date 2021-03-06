# == Schema Information
#
# Table name: magaz_variants
#
#  id         :integer          not null, primary key
#  product_id :integer
#  price      :decimal(8, 2)
#  name       :string
#  hidden     :boolean          default(FALSE)
#  position   :integer
#  stock      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  permalink  :string
#

FactoryGirl.define do
  factory :magaz_variant, :class => 'Magaz::Variant' do
    association :product, factory: :magaz_product
    price { Faker::Commerce.price }
    name { Faker::Lorem.word }
  end

end
