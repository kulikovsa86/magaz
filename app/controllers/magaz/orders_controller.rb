require_dependency "magaz/application_controller"

module Magaz
  class OrdersController < ApplicationController

    before_action :set_order, only: [:edit, :update, :destroy]

    # GET    /orders(.:format)
    def index
      @orders = Order.order(created_at: :desc)
    end

    # GET    /orders/new(.:format)
    def new
      @order = Order.new
    end

    # POST   /orders(.:format)
    def create
      @order = Order.new(order_params)
      if @order.save
        redirect_to edit_order_path(@order), notice: t('.success')
      else
        render :new
      end
    end

    # GET    /orders/:id/edit(.:format)
    def edit
    end

    # PATCH/PUT  /orders/:id(.:format)
    def update
      if @order.update(order_params)
        redirect_to edit_order_path(@order), notice: t('.success')
      else
        render :edit
      end
    end

    # DELETE /orders/:id(.:format)
    def destroy
      @order.destroy
      redirect_to orders_path, notice: t('.success')
    end

    private

      def set_order
        @order = Order.find(params[:id])
      end

      def order_params
        params.require(:order).permit(:customer, :company, :phone, :email, :delivery_id, :address1, :address2, :address3, :address4, :post_code, :payment_id, :status_id, :pdt, :manager_comment)
      end 

  end
end