# == Schema Information
#
# Table name: magaz_comments
#
#  id         :integer          not null, primary key
#  name       :string
#  text       :text
#  rate       :integer
#  accepted   :boolean          default(FALSE)
#  fresh      :boolean          default(TRUE)
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Magaz
  class Comment < ActiveRecord::Base
    belongs_to :product

    validates :name, :text, presence: true

    def self.fresh
      Comment.where(fresh: true).order(created_at: :desc)
    end

    # удаление комментариев
    # params = {:items => [{id: id, checked: true}, ...]}
    # id - идентификатор комментария, checked - комментарий выбран
    def self.shift(params)
      comment_ids = params[:items].select{|item| item[:checked]}.map{|item| item[:id]}
      Comment.where(:id => comment_ids).destroy_all
    end

  end
end
