# == Schema Information
#
# Table name: magaz_payments
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  note       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :magaz_payment, :class => 'Magaz::Payment' do
    code "MyString"
name "MyString"
note "MyText"
  end

end
