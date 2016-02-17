require_dependency "magaz/application_controller"

module Magaz
  class LineItemsController < ApplicationController

    before_action :set_line_item, only: [:destroy]

    # POST   /line_items(.:format)
    def create
    end

    # DELETE /line_items/:id(.:format)
    def destroy
      order = @line_item.order
      @line_item.destroy
      notify( event_type: 'order item deleted', order: order.id )
      redirect_to edit_items_order_path(order)
    end 

    private

      def set_line_item
        @line_item = LineItem.find(params[:id])
      end

  end
end