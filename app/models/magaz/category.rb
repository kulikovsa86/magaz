# == Schema Information
#
# Table name: magaz_categories
#
#  id          :integer          not null, primary key
#  code        :string
#  name        :string
#  description :string
#  hidden      :boolean
#  parent_id   :integer
#  position    :integer
#  permalink   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module Magaz
  class Category < ActiveRecord::Base
    acts_as_tree dependent: :destroy
    acts_as_list scope: :parent
    has_permalink :translit_name

    has_many :products, dependent: :destroy
    has_many :property_values, as: :valuable
    has_many :properties, through: :property_values

    validates :name, presence: true

    def static_properties
      properties.where(static: true)
    end

    def dynamic_properties
      properties.where(static: false)
    end

    private
      def translit_name
        if name
          Translit.convert(name, :english)
        else
          nil
        end
      end
  end
end
