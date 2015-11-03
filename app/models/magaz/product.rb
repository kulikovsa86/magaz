# == Schema Information
#
# Table name: magaz_products
#
#  id          :integer          not null, primary key
#  name        :string
#  category_id :integer
#  description :text
#  price       :decimal(8, 2)
#  hidden      :boolean
#  article     :string
#  weight      :decimal(6, 3)
#  position    :integer
#  permalink   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module Magaz
  class Product < ActiveRecord::Base
    has_permalink :translit_name

    belongs_to :category
    acts_as_list scope: :category

    has_many :variants, dependent: :destroy

    validates :name, presence: true

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
