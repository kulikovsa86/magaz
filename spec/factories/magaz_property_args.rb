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

FactoryGirl.define do
  factory :magaz_property_arg, :class => 'Magaz::PropertyArg' do
    property nil
min "9.99"
max "9.99"
step "9.99"
default "9.99"
  end

end
