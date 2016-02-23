# == Schema Information
#
# Table name: magaz_property_values
#
#  id            :integer          not null, primary key
#  property_id   :integer
#  value         :string
#  valuable_id   :integer
#  valuable_type :string
#  position      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :magaz_property_value, :class => 'Magaz::PropertyValue' do
  end
end
