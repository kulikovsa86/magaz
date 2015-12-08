# == Schema Information
#
# Table name: magaz_profiles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  first_name :string
#  last_name  :string
#  phone      :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :magaz_profile, :class => 'Magaz::Profile' do
    users nil
first_name "MyString"
last_name "MyString"
phone "MyString"
email "MyString"
  end

end
