# == Schema Information
#
# Table name: magaz_property_options
#
#  id          :integer          not null, primary key
#  property_id :integer
#  code        :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position    :integer
#

require 'faker'

FactoryGirl.define do
  factory :magaz_property_option, :class => 'Magaz::PropertyOption' do
    name { Faker::Lorem.sentence  }
  end

end
