# == Schema Information
#
# Table name: magaz_categories
#
#  id          :integer          not null, primary key
#  code        :string
#  name        :string
#  description :string
#  hidden      :boolean
#  parent_id   :integer
#  sort_order  :integer
#  permalink   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe Category, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
