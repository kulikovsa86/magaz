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

module Magaz
  class OrderStatus < ActiveRecord::Base
    belongs_to :order
    belongs_to :status
  end
end
