# == Schema Information
#
# Table name: magaz_comments
#
#  id         :integer          not null, primary key
#  name       :string
#  text       :text
#  rate       :integer
#  accepted   :boolean          default(FALSE)
#  fresh      :boolean          default(TRUE)
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :magaz_comment, :class => 'Magaz::Comment' do
    name "MyString"
text "MyText"
rate 1
accepted false
product nil
  end

end
