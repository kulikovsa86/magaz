# == Schema Information
#
# Table name: magaz_dimensions
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  full_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Magaz
  class Dimension < ActiveRecord::Base

    def to_s
      "#{full_name} (#{name})"
    end

    def self.default
      Dimension.find_by(code: '01')
    end
  end
end
