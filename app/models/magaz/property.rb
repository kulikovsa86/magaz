# == Schema Information
#
# Table name: magaz_properties
#
#  id                :integer          not null, primary key
#  code              :string
#  name              :string
#  description       :text
#  property_type_id  :integer
#  static            :boolean
#  position          :integer
#  property_group_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

module Magaz
  class Property < ActiveRecord::Base

    belongs_to :property_group
    acts_as_list scope: :property_group


    belongs_to :property_type
    has_many :property_options, -> { order(position: :asc) }, dependent: :destroy

    # validates :code, :name, presence: true
    # validates :code, allow_blank: true, uniqueness: true

    def options
      property_options
    end

    def type
      property_type
    end

    def group
      property_group
    end

    def self.create_combo(name, options)
      prop = Property.create(name: name, property_type: PropertyType.LIST)
      options.each { |opt| prop.options << PropertyOption.create(name: opt) }
      prop
    end

    def self.create_number(name)
      Property.create(name: name, property_type: PropertyType.NUMBER)
    end

  end
end
