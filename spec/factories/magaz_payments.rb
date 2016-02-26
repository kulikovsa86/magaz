# == Schema Information
#
# Table name: magaz_payments
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  note       :text
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :magaz_payment, :class => 'Magaz::Payment' do
    code { Faker::Number.number(5) }
    name { Faker::Lorem.sentence }
    note { Faker::Lorem.paragraph }
  end
end
