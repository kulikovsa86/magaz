# == Schema Information
#
# Table name: magaz_line_items
#
#  id          :integer          not null, primary key
#  product_id  :integer
#  variant_id  :integer
#  price       :decimal(8, 2)
#  count       :integer
#  total_count :decimal(8, 3)
#  manual      :boolean          default(FALSE)
#  ratio       :decimal(8, 3)
#  cart_id     :integer
#  order_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

module Magaz
  RSpec.describe LineItemsController, type: :controller do

    routes { Magaz::Engine.routes }

    before :each do
      sign_in create(:magaz_user)
    end

    describe "DELETE #destroy" do

      before :each do
        @item = create(:magaz_line_item_in_order)
      end

      subject { delete :destroy, id: @item.id }
        
      it "deletes the instance" do
        expect{ subject }.to change{ LineItem.count }.by(-1)
      end

      it "notifies custom event" do
        expect{ subject }.to instrument("magaz.custom_event").with(options: {event_type: 'order item deleted', order: @item.order.id})
      end

      it "redirects to order items" do
        delete :destroy, id: @item.id
        expect(response).to redirect_to(edit_items_order_path(@item.order))
      end
    end
  end
end
