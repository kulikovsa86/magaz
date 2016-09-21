# == Schema Information
#
# Table name: magaz_property_groups
#
#  id         :integer          not null, primary key
#  name       :string
#  code       :string
#  parent_id  :integer
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Magaz
  class PropertyGroup < ActiveRecord::Base
    acts_as_tree dependent: :destroy
    acts_as_list scope: :parent

    has_many :properties, dependent: :destroy

    validates :name, presence: true

    def invariant_properties
      properties.where(variant: false)
    end


    def self.options
      options = []
      PropertyGroup.leaves.group_by(&:parent).each do |key, value|
        group = ''
        group = key[:name] if key
        items = value.map { |prop| [prop[:name], prop[:id]] }
        options += [[group, items]]
      end
      options
    end

    def add_combo_property(name, options, args = {})
      properties << Property.create_combo(name, options, args)
    end

    def add_number_property(name, args = {})
      prop = Property.create_number(name, args)
      if args.size
        [:min, :max, :step, :default].each do |key|
          prop.property_arg[key] = args[key] if args[key]
        end
        prop.property_arg.save
      end
      properties << prop
    end

    def add_float_property(name, args = {})
      properties << Property.create_float(name, args)
    end

    def add_string_property(name, args = {})
      properties << Property.create_string(name, args)
    end

  end
end
