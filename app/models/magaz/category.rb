# == Schema Information
#
# Table name: magaz_categories
#
#  id          :integer          not null, primary key
#  code        :string
#  name        :string
#  description :string
#  hidden      :boolean          default(TRUE)
#  parent_id   :integer
#  position    :integer
#  permalink   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module Magaz
  class Category < ActiveRecord::Base

    after_save :clean_desc_properties

    acts_as_tree dependent: :destroy
    acts_as_list scope: :parent
    has_permalink :translit_name

    has_many :products, dependent: :destroy
    has_many :property_values, as: :valuable
    has_many :properties, through: :property_values
    has_and_belongs_to_many :property_groups

    validates :name, presence: true

    def static_properties
      properties.where(static: true)
    end

    def dynamic_properties
      properties.where(static: false)
    end

    def self.options
      opts = []
      Magaz::Category.leaves.order(:parent_id, :position).each do |cat|
        subtext = cat.ancestry_path[0..-2].join('/')
        opts += [[cat.name, cat.id, {'data-subtext' => subtext}]]
      end
      opts
    end

    def clean_desc_properties
      # --- удаляем характеристики в модификациях, которых (уже) нет в категориях
      Magaz::PropertyValue.where(valuable_type: Magaz::Variant, valuable_id: Magaz::Variant.where(product_id:product_ids).ids).where.not(property: Magaz::Property.where(property_group: property_groups)).destroy_all
      # --- удаляем характеристики в товарах, которых (уже) нет в категориях
      Magaz::PropertyValue.where(valuable_type: Magaz::Product, valuable_id: product_ids).where.not(property: Magaz::Property.where(property_group: property_groups)).destroy_all
    end

    private
  
      def translit_name
        if name
          Translit.convert(name, :english)
        else
          nil
        end
      end

      # p.property_values.where.not(property: Magaz::Property.where(property_group: c.property_groups)).destroy_all
  end
end
