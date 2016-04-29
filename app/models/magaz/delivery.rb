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

    PICKUP_CODE = '01'
    COURIER_CODE = '02'
    POST_CODE = '03'

    def self.pickup 
      Delivery.find_by(code: Delivery::PICKUP_CODE)
    end

    def self.courier
      Delivery.find_by(code: Delivery::COURIER_CODE)
    end

    def self.post
      Delivery.find_by(code: Delivery::POST_CODE)
    end

    validates :name, presence: true

  end
end
