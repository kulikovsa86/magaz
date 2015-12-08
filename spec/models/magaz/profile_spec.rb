# == Schema Information
#
# Table name: magaz_profiles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  first_name :string
#  last_name  :string
#  phone      :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe Profile, type: :model do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
