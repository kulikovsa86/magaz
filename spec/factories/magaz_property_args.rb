# == Schema Information
#
# Table name: magaz_property_args
#
#  id          :integer          not null, primary key
#  property_id :integer
#  min         :decimal(, )
#  max         :decimal(, )
#  step        :decimal(, )
#  default     :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#


require 'faker'

FactoryGirl.define do
  factory :magaz_property_arg, :class => 'Magaz::PropertyArg' do
    association :property, factory: :magaz_property
    min { Faker::Number.between(1, 5) }
    max { Faker::Number.between(10, 15) }
    step { Faker::Number.between(1, 2) }
    default { Faker::Number.between(1, 15) }
  end

end
