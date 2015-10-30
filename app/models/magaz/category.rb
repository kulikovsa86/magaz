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
#  sort_order  :integer
#  permalink   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module Magaz
  class Category < ActiveRecord::Base
    acts_as_tree
    acts_as_list scope: :parent
    has_permalink :translit_name

    has_and_belongs_to_many :properties
    has_many :products, dependent: :destroy

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
