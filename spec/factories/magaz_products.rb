# == Schema Information
#
# Table name: magaz_products
#
#  id          :integer          not null, primary key
#  name        :string
#  category_id :integer
#  description :text
#  price       :decimal(8, 2)
#  hidden      :boolean
#  article     :string
#  weight      :decimal(6, 3)
#  permalink   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :magaz_product, :class => 'Magaz::Product' do
    name "MyString"
category nil
description "MyText"
price "9.99"
hidden false
article "MyString"
weight "9.99"
  end

end
