# == Schema Information
#
# Table name: magaz_properties
#
#  id                :integer          not null, primary key
#  code              :string
#  name              :string
#  description       :text
#  property_type_id  :integer
#  static            :boolean          default(FALSE)
#  variant           :boolean          default(FALSE)
#  position          :integer
#  property_group_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  property_kind_id  :integer
#

module Magaz
  class Property < ActiveRecord::Base

    acts_as_list scope: :property_group

    before_create :check_kind
    after_create :create_property_arg

    belongs_to :property_group
    acts_as_list scope: :property_group

    belongs_to :property_type
    has_many :property_options, -> { order(position: :asc) }, dependent: :destroy

    belongs_to :property_kind

    has_many :property_values, dependent: :destroy
    has_one :property_arg, dependent: :destroy

    validates :name, presence: true

    def options
      property_options
    end

    def type
      property_type
    end

    def group
      property_group
    end

    def self.create_combo(name, options, args = {})
      prop = Property.create(name: name, code: args[:code], property_type: PropertyType.list, static: args[:static], variant: args[:variant])
      options.each { |opt| prop.options << PropertyOption.create(name: opt) }
      prop
    end

    def self.create_number(name, args = {})
      Property.create(name: name, code: args[:code], property_type: PropertyType.number, static: args[:static], variant: args[:variant])
    end

    def self.create_float(name, args = {})
      Property.create(name: name, code: args[:code], property_type: PropertyType.float, static: args[:static], variant: args[:variant])
    end

    def self.create_string(name, args = {})
      Property.create(name: name, code: args[:code], property_type: PropertyType.string, static: args[:static], variant: args[:variant])
    end

    def rand_value
      value = case type.code
      when PropertyType::LIST_CODE
        options[Random.rand(options.size)].name
      when (PropertyType::NUMBER_CODE || PropertyType::FLOAT_CODE)
        property_arg.rand.to_s
      when PropertyType::STRING_CODE
        Faker::Lorem.sentence
      when PropertyType::TEXT_CODE
        Faker::Lorem.paragraph
      when PropertyType::BOOL_CODE
        [true, false].sample
      when PropertyType::COLOR_CODE
        Faker::Color.hex_color
      end
      value
    end

    def feature?
      property_kind.feature?
    end

    def variant?
      property_kind.variant?
    end

    def special?
      property_kind.special?
    end

    private

      def check_kind
        self.property_kind = PropertyKind::FEATURE unless property_kind_id
      end

      def create_property_arg
        if property_type == PropertyType.number
          build_property_arg
        end
        true
      end

  end
end
