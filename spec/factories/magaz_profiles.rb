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


require 'faker'

FactoryGirl.define do
  factory :magaz_profile, :class => 'Magaz::Profile' do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.cell_phone }
  end
end
