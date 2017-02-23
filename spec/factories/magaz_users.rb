# == Schema Information
#
# Table name: magaz_users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :magaz_user, :class => 'Magaz::User' do
    email { Faker::Internet.free_email(Faker::Name.last_name) }
    password { Faker::Internet.password(8) }
    association :profile, factory: :magaz_profile
  end
end