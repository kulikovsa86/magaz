# == Schema Information
#
# Table name: magaz_dimensions
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  full_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :magaz_dimension, :class => 'Magaz::Dimension' do
    code "MyString"
name "MyString"
  end

end
