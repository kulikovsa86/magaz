# == Schema Information
#
# Table name: magaz_deliveries
#
#  id                 :integer          not null, primary key
#  code               :string
#  name               :string
#  note               :text
#  address_required   :boolean
#  post_code_required :boolean
#  price              :decimal(8, 2)
#  position           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

module Magaz
  class Delivery < ActiveRecord::Base
    acts_as_list
  end
end
