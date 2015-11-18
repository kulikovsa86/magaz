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
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :magaz_delivery, :class => 'Magaz::Delivery' do
    code "MyString"
name "MyString"
note "MyText"
  end

end
