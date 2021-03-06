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
#  liable_id   :integer
#  liable_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  note        :string
#

require 'rails_helper'

module Magaz
  RSpec.describe LineItemsController, type: :controller do

    routes { Magaz::Engine.routes }

    let (:user) { create(:magaz_user) }

    before :each do
      sign_in user
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
        expect{ subject }.to instrument("magaz.custom_event").with(options: {event_type: 'status updated', order: @item.liable_id, user: user.id})
      end

      it "redirects to order items" do
        delete :destroy, id: @item.id
        expect(response).to redirect_to(orders_path)
      end
    end
  end
end
