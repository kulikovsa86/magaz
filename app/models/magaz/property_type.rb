# == Schema Information
#
# Table name: magaz_property_types
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Magaz
  class PropertyType < ActiveRecord::Base
    belongs_to :property

    validates :code, :name, presence: true
    validates :code, allow_blank: true, uniqueness: true

    def self.list
      PropertyType.find_by(code: '01')
    end

    def self.number
      PropertyType.find_by(code: '02')
    end

  end
end
