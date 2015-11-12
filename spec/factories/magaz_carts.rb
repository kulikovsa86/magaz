# == Schema Information
#
# Table name: magaz_carts
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :magaz_cart, :class => 'Magaz::Cart' do
    
  end

end
