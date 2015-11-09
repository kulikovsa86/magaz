# == Schema Information
#
# Table name: magaz_images
#
#  id             :integer          not null, primary key
#  picture        :string
#  imageable_id   :integer
#  imageable_type :string
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe Image, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
