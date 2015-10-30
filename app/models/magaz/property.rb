# == Schema Information
#
# Table name: magaz_properties
#
#  id               :integer          not null, primary key
#  code             :string
#  name             :string
#  property_type_id :integer
#  static           :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

module Magaz
  class Property < ActiveRecord::Base
    belongs_to :property_type
    has_many :property_options, -> { order(position: :asc) }, dependent: :destroy

    validates :code, :name, presence: true
    validates :code, allow_blank: true, uniqueness: true

    def options
      property_options
    end

    def type
      property_type
    end

  end
end
