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
#

module Magaz
  class Property < ActiveRecord::Base

    acts_as_list scope: :property_group

    after_create :create_property_arg

    belongs_to :property_group
    acts_as_list scope: :property_group

    belongs_to :property_type
    has_many :property_options, -> { order(position: :asc) }, dependent: :destroy

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

    def self.create_combo(name, options)
      prop = Property.create(name: name, property_type: PropertyType.list)
      options.each { |opt| prop.options << PropertyOption.create(name: opt) }
      prop
    end

    def self.create_number(name)
      Property.create(name: name, property_type: PropertyType.number)
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

    private

      def create_property_arg
        if property_type == PropertyType.number
          build_property_arg
        end
        true
      end

  end
end
