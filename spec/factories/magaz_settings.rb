# == Schema Information
#
# Table name: magaz_settings
#
#  id         :integer          not null, primary key
#  name       :string
#  value      :string
#  param      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :magaz_setting, :class => 'Magaz::Setting' do
    name "MyString"
value "MyString"
param "MyString"
  end

end
