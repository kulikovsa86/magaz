# == Schema Information
#
# Table name: magaz_order_statuses
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  status_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :magaz_order_status, :class => 'Magaz::OrderStatus' do
    
  end
end
