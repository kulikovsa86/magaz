# == Schema Information
#
# Table name: magaz_comments
#
#  id         :integer          not null, primary key
#  name       :string
#  text       :text
#  rate       :integer
#  accepted   :boolean
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Magaz
  class Comment < ActiveRecord::Base
    belongs_to :product

    def self.fresh
      Comment.where(fresh: true).order(created_at: :desc)
    end
  end
end
