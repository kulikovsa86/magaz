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

    validates :name, presence: true
    
  end
end
