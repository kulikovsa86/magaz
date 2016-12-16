# == Schema Information
#
# Table name: magaz_categories
#
#  id          :integer          not null, primary key
#  code        :string
#  name        :string
#  description :text
#  hidden      :boolean          default(TRUE)
#  parent_id   :integer
#  position    :integer
#  permalink   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module Magaz
  class Category < ActiveRecord::Base

    after_save :set_image
    after_save :clean_desc_properties

    acts_as_tree dependent: :destroy
    acts_as_list scope: :parent
    has_permalink :translit_name

    has_many :products, dependent: :destroy
    has_many :property_values, as: :valuable
    has_and_belongs_to_many :property_groups
    has_one :image, as: :imageable, dependent: :destroy

    validates :name, presence: true

    attr_accessor :picture


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

    def all_products
      Magaz::Product.where(category: self_and_descendants)
    end

    def all_variants
      Magaz::Variant.where(product: all_products)
    end

    private
  
      def translit_name
        if name
          translit = Translit.convert(name, :english)
          find_permalink(translit.parameterize)
        else
          nil
        end
      end

      def find_permalink(permalink, index = nil)
        if index.nil?
          permalink = find_permalink(permalink, 2) if Magaz::Category.find_by_permalink(permalink)
        else
          if Magaz::Category.find_by_permalink("#{permalink}-#{index}")
            permalink = find_permalink(permalink, index + 1) 
          else
            permalink = "#{permalink}-#{index}"
          end
        end
        permalink
      end

      def set_image
        self.image = Magaz::Image.create(picture: picture) if picture
      end
  end
end
