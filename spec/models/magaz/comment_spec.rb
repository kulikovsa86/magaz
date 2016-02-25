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

require 'rails_helper'

module Magaz
  RSpec.describe Comment, type: :model do
    
    before :each do
      @comment = create(:magaz_comment)
    end

    it "has a valid factory" do
      expect(@comment).to be_valid
    end

    it "can shift" do
      total_count = Random.rand(10)
      checked_count = total_count - Random.rand(9)
      product = create(:magaz_product_with_comments, comment_count: total_count)
      items = product.comments.map{ |c| Hash[:id, c.id, :checked, false] }
      0.upto(checked_count - 1) { |i| items[i][:checked] = true }
      Comment.shift({ items: items })
      product.reload
      expect(product.comments.size).to eq(total_count - checked_count)
    end
  end
end
