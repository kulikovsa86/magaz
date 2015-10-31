# == Schema Information
#
# Table name: magaz_variants
#
#  id         :integer          not null, primary key
#  product_id :integer
#  price      :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :magaz_variant, :class => 'Magaz::Variant' do
    product nil
price "9.99"
  end

end
