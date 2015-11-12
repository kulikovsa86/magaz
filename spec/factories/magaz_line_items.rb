# == Schema Information
#
# Table name: magaz_line_items
#
#  id         :integer          not null, primary key
#  product_id :integer
#  variant_id :integer
#  price      :decimal(8, 2)
#  count      :integer
#  cart_id    :integer
#  order_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :magaz_line_item, :class => 'Magaz::LineItem' do
    product nil
variant nil
price "9.99"
count 1
cart nil
order_id 1
  end

end
