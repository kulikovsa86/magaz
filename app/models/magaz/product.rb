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
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

module Magaz
  class Product < ActiveRecord::Base
    has_permalink :translit_name

    belongs_to :category
    acts_as_list scope: :category
    belongs_to :input_dim, :class_name => "Dimension"
    belongs_to :calc_dim, :class_name => "Dimension"

    has_many :variants, dependent: :destroy
    has_many :images, as: :imageable, dependent: :destroy
    has_many :property_values, as: :valuable, dependent: :destroy
    has_many :comments

    validates :name, :category, presence: true
    validates :name, allow_blank: true, uniqueness: true, length: { maximum: 144 }

    # Устанавливаем значения характеристик товара
    # properties = [{property_id: "", value: ""}, ...]
    def set_properties(properties)
      property_values.clear
      properties.each do |pv|
        next unless pv[:value]
        property_values.create(property_id: pv[:property_id], value: pv[:value])
      end
    end

    def value(property_id)
      pv = property_values.find_by(property_id: property_id)
      if pv
        pv.value
      else
        ''
      end
    end

    # Перемещение/удаление товаров
    # params = {:parent => permalink, :target => target, :items => [{id: id, checked: true}, ...]}
    # target - id категории (для перемещения)
    # id - идентификатор товара, checked - товар выбран
    # remove_flag - флаг операции удаления
    def self.shift(params, remove_flag)
      product_ids = params[:items].select{|item| item[:checked]}.map{|item| item[:id]}
      if remove_flag
        Product.where(:id => product_ids).destroy_all
      else
        category = Category.find(params[:target])
        category.products << Product.find(product_ids)
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
      property_values.each do |pv|
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

    private
      def default_dimension
        dim = Dimension.default
        if dim
          dim.name
        else
          '?'
        end
      end

      def translit_name
        if name
          Translit.convert(name, :english)
        else
          nil
        end
      end
  end
end
