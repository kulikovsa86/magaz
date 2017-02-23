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

module Magaz
  class Profile < ActiveRecord::Base
    belongs_to :users

    validates :first_name, :last_name, :phone, :email, presence: true

  end
end
