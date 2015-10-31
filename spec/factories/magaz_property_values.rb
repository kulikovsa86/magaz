# == Schema Information
#
# Table name: magaz_property_values
#
#  id          :integer          not null, primary key
#  variant_id  :integer
#  property_id :integer
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :magaz_property_value, :class => 'Magaz::PropertyValue' do
    variant nil
property nil
value "MyString"
  end

end
