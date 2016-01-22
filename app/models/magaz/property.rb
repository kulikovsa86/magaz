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
#  variant           :boolean
#  position          :integer
#  property_group_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

module Magaz
  class Property < ActiveRecord::Base

    after_create :create_property_arg

    belongs_to :property_group
    acts_as_list scope: :property_group

    belongs_to :property_type
    has_many :property_options, -> { order(position: :asc) }, dependent: :destroy

    has_many :property_values, dependent: :destroy
    has_one :property_arg, dependent: :destroy

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

    private

      def create_property_arg
        if property_type == PropertyType.NUMBER
          build_property_arg
        end
        true
      end

  end
end
