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

require 'rails_helper'

module Magaz
  RSpec.describe OrderStatus, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
