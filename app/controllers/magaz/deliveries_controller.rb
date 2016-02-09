require_dependency "magaz/application_controller"

module Magaz
  class DeliveriesController < ApplicationController

    before_action :set_delivery, only: [:edit, :update, :destroy, :up, :down]

    # GET    /deliveries(.:format)
    def index
      @deliveries = Delivery.order(:position)
    end

    # GET    /deliveries/new(.:format)
    def new
      @delivery = Delivery.new
    end

    # POST   /deliveries(.:format)
    def create
      @delivery = Delivery.new(delivery_params)
      if @delivery.save
        redirect_to edit_delivery_path(@delivery), notice: t('.success')
      else
        render :new
      end
    end

    # GET    /deliveries/:id/edit(.:format)
    def edit
    end

    # PATCH/PUT  /deliveries/:id(.:format)
    def update
      if @delivery.update(delivery_params)
        redirect_to edit_delivery_path(@delivery), notice: t('.success')
      else
        render :edit
      end
    end

    # PATCH  /deliveries/:delivery_id/up(.:format)
    def up
      @delivery.move_higher
      redirect_to deliveries_path
    end

    # PATCH  /deliveries/:delivery_id/down(.:format) 
    def down
      @delivery.move_lower
      redirect_to deliveries_path
    end

    # DELETE /deliveries/:id(.:format)
    def destroy
      @delivery.destroy
      redirect_to deliveries_path, notice: t('.success')
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_delivery
        if params[:id]
          @delivery = Delivery.find(params[:id])
        else
          @delivery = Delivery.find(params[:delivery_id])
        end
      end

      def delivery_params
        params.require(:delivery).permit(:code, :name, :note, :address_required, :post_code_required, :price)
      end

  end
end
