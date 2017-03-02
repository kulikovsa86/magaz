# == Schema Information
#
# Table name: magaz_variants
#
#  id         :integer          not null, primary key
#  product_id :integer
#  price      :decimal(8, 2)
#  name       :string
#  hidden     :boolean          default(FALSE)
#  position   :integer
#  stock      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  permalink  :string
#

module Magaz
  class Variant < ActiveRecord::Base
    has_permalink :translit_name

    belongs_to :product, touch: true
    acts_as_list scope: :product
    
    has_many :property_values, as: :valuable, dependent: :destroy
    has_many :variant_images, dependent: :destroy
    has_many :images, through: :variant_images

    scoped_search on: :name
    scoped_search :relation => :product, on: [:name, :description]
    


    validates :name, presence: true

    def features
      property_values.features
    end

    def spec_value(code)
      property_values.joins(:property).where('magaz_properties' => { code: code }).first
    end

    # properties = [{property_id: "", value: ""}, ...]
    def set_properties(properties)
      property_values.clear
      properties.each do |pv|
        next if (!pv[:value] || pv[:value].empty?)
        property_values.create(property_id: pv[:property_id], value: pv[:value])
      end
    end

    def value(property_id, args = {})
      pv = property_values.find_by(property_id: property_id)
      if pv
        pv.value
      else
        ''
      end
    end

    def values_string
      values = []
      features.each do |pv|
        if pv.property && pv.property.type.code != '10'
          if pv.property.type.code == '04'
            values << (pv.value.gsub(/<\/?[^>]*>/, "")[0..15] + '...')
          elsif pv.property.type.code == '05' && pv.value
            values << pv.property.name
          else
            values << pv.value
          end
        end
      end
      values.join(', ')
    end

    def colors_string
      colors = ''
      property_values.each do |pv|
        if pv.property && pv.property.type.code == '10'
          colors << "<div class='small-colored-square' style='background-color:##{pv.value};'></div>"
        end
      end
      colors
    end

    def pretty_title
      if product.title && !product.title.empty?
        "#{product.title}" % {
          product_name: product.name, 
          product_short_name: product.short_name,
          name: name,
          product_var_name: product.var_name,
          description: product.description}
      else
        name
      end
    rescue KeyError
      "Ошибка формата заголовока страницы"
    end

    def pretty_description
      if product.meta_description && !product.meta_description.empty?
        "#{product.meta_description}" % {
          product_name: product.name, 
          product_short_name: product.short_name,
          name: name,
          product_var_name: product.var_name,
          description: product.description}
      else
        product.description
      end
    rescue KeyError
      "Ошибка формата мета-описания"
    end

    class << self

      def latest
        Magaz::Variant.order(:updated_at).last
      end

      # удаление модификаций
      # params = {'product' => permalink, items = [{id: id, checked: true}, ...]}
      # id - идентификатор модификации, checked - модификация выбрана
      # remove_flag - флаг операции удаления
      def shift(params, remove_flag)
        variant_ids = params[:items].select{|item| item[:checked]}.map{|item| item[:id]}
        if remove_flag
          Variant.where(:id => variant_ids).destroy_all
        end
      end
    end

    private

      def find_permalink(permalink, index = nil)
        if index.nil?
          permalink = find_permalink(permalink, 2) if Magaz::Variant.find_by_permalink(permalink)
        else
          if Magaz::Variant.find_by_permalink("#{permalink}-#{index}")
            permalink = find_permalink(permalink, index + 1) 
          else
            permalink = "#{permalink}-#{index}"
          end
        end
        permalink
      end


      def translit_name
        if name
          translit = Translit.convert(name, :english)
          find_permalink(translit.parameterize)
        else
          nil
        end
      end

  end
end
