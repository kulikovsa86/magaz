# == Schema Information
#
# Table name: magaz_payments
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  note       :text
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Magaz
  class Payment < ActiveRecord::Base
    acts_as_list

    NON_CASH_CODE = '01'
    CASH_CODE = '02'

    validates :name, presence: true

    def self.non_cash
      Payment.find_by(code: Payment::NON_CASH_CODE)
    end

    def self.cash
      Payment.find_by(code: Payment::CASH_CODE)
    end
    
  end
end
