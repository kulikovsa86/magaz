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
#

FactoryGirl.define do
  factory :magaz_order, :class => 'Magaz::Order' do
    customer "MyString"
phone "MyString"
email "MyString"
delivery nil
address1 "MyString"
address2 "MyString"
address3 "MyString"
address4 "MyString"
post_code "MyString"
payment nil
status nil
  end

end
