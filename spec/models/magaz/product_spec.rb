# == Schema Information
#
# Table name: magaz_products
#
#  id          :integer          not null, primary key
#  name        :string
#  category_id :integer
#  description :text
#  price       :decimal(8, 2)
#  hidden      :boolean
#  article     :string
#  weight      :decimal(6, 3)
#  permalink   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe Product, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
