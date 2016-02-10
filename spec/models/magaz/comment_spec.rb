# == Schema Information
#
# Table name: magaz_comments
#
#  id         :integer          not null, primary key
#  name       :string
#  text       :text
#  rate       :integer
#  accepted   :boolean
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe Comment, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
