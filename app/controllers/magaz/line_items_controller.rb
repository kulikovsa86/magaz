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
#

require_dependency "magaz/application_controller"

module Magaz
  class LineItemsController < ApplicationController

    before_action :set_line_item, only: :destroy

    # DELETE /line_items/:id(.:format)
    def destroy
      order = @line_item.liable
      @line_item.destroy
      unless order.line_items.any?
        order.cancel
        notify( event_type: 'status updated', order: order.id, user: current_user.id )
        redirect_to orders_path, notice: "Заказ отменен"
      else
        notify( event_type: 'order item deleted', order: order.id, user: current_user.id )
        redirect_to edit_items_order_path(order)
      end
    end 

    private

      def set_line_item
        @line_item = LineItem.find(params[:id])
      end
  end
end
