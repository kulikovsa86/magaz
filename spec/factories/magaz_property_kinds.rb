# == Schema Information
#
# Table name: magaz_property_kinds
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :magaz_property_kind, :class => 'Magaz::PropertyKind' do
    code "MyString"
name "MyString"
  end

end
