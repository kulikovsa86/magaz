# == Schema Information
#
# Table name: magaz_images
#
#  id             :integer          not null, primary key
#  picture        :string
#  imageable_id   :integer
#  imageable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :magaz_image, :class => 'Magaz::Image' do
    name "MyString"
  end

end
