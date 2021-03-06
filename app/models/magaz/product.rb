# == Schema Information
#
# Table name: magaz_products
#
#  id           :integer          not null, primary key
#  name         :string
#  var_name     :string
#  category_id  :integer
#  description  :text
#  price        :decimal(8, 2)
#  hidden       :boolean          default(TRUE)
#  article      :string
#  weight       :decimal(6, 3)
#  position     :integer
#  permalink    :string
#  input_dim_id :integer
#  calc_dim_id  :integer
#  correct      :boolean          default(FALSE)
#  moulded      :boolean          default(FALSE)
#  stock        :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  short_name   :string
#

module Magaz
  class Product < ActiveRecord::Base
    has_permalink :translit_name

    belongs_to :category, touch: true
    acts_as_list scope: :category
    belongs_to :input_dim, :class_name => "Dimension"
    belongs_to :calc_dim, :class_name => "Dimension"

    has_many :line_items, dependent: :destroy
    has_many :variants, dependent: :destroy
    has_many :images, as: :imageable, dependent: :destroy
    has_many :property_values, as: :valuable, dependent: :destroy
    has_many :comments, dependent: :destroy

    scoped_search on: [:name, :description]
    scoped_search :relation => :variants, on: :name

    scope :visible, -> {where(hidden: false)}

    validates :name, :category, presence: true
    validates :name, allow_blank: false, length: { maximum: 144 }

    def features
      property_values.features
    end

    def spec_value(code)
      property_values.joins(:property).where('magaz_properties' => { code: code }).first
    end

    # Устанавливаем значения характеристик товара
    # properties = [{property_id: "", value: ""}, ...]
    def set_properties(properties)
      property_values.clear
      properties.each do |pv|
        next unless pv[:value]
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

    def input_dim_name
      if input_dim
        input_dim.name
      else
        default_dimension
      end
    end

    def calc_dim_name
      if calc_dim
        calc_dim.name
      elsif
        default_dimension
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

    def rand_properties
      property_values.clear
      category.property_groups.each do |pg|
        pg.properties.each do |prop|
          property_values.create(property_id: prop.id, value: prop.rand_value)
        end
      end
    end

    def pretty_title
      if title && !title.empty?
        "#{title}" % {
          name: name, 
          short_name: short_name, 
          var_name: var_name,
          description: description}
      else
        name
      end
    rescue KeyError
      "Ошибка формата заголовока страницы"
    end

    def pretty_description
      if meta_description && !meta_description.empty?
        md = meta_description.gsub("%", "%%")
        "#{md}" % {
          name: name, 
          short_name: short_name, 
          var_name: var_name,
          description: description}
      else
        description
      end
    rescue KeyError
      "Ошибка формата мета-описания"
    end

    class << self

      def latest
        Magaz::Product.order(:updated_at).last
      end

      # Перемещение/удаление товаров
      # params = {:parent => permalink, :target => target, :items => [{id: id, checked: true}, ...]}
      # target - id категории (для перемещения)
      # id - идентификатор товара, checked - товар выбран
      # remove_flag - флаг операции удаления
      def shift(params, remove_flag)
        product_ids = params[:items].select{|item| item[:checked]}.map{|item| item[:id]}
        if remove_flag
          Product.where(:id => product_ids).destroy_all
        else
          category = Category.find(params[:target])
          category.products << Product.find(product_ids)
        end
      end

    end

    private
      def default_dimension
        dim = Dimension.default
        if dim
          dim.name
        else
          '?'
        end
      end

      def find_permalink(permalink, index = nil)
        if index.nil?
          permalink = find_permalink(permalink, 2) if Magaz::Product.find_by_permalink(permalink)
        else
          if Magaz::Product.find_by_permalink("#{permalink}-#{index}")
            permalink = find_permalink(permalink, index + 1) 
          else
            permalink = "#{permalink}-#{index}"
          end
        end
        permalink
      end


      def translit_name
        if name
          translit = Translit.convert("#{category.name} #{name}", :english)
          find_permalink(translit.parameterize)
        else
          nil
        end
      end
  end
end
