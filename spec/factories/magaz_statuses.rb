# == Schema Information
#
# Table name: magaz_statuses
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  note       :text
#  closed     :boolean          default(FALSE)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :magaz_status, :class => 'Magaz::Status' do
    code { Faker::Number.number(5) }
    name { Faker::Lorem.word }
    note { Faker::Lorem.paragraph }
  end
end
