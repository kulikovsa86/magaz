require_dependency "magaz/application_controller"

module Magaz
  class OrdersController < ApplicationController

    before_action :set_order, only: [:edit, :update, :destroy, :edit_items, :edit_contacts, :edit_delivery, :edit_payment, :recount]

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

    # GET    /orders/:id/edit_items(.:format)
    def edit_items
      @form = 'form_items'
      render :edit
    end

    # GET    /orders/:id/edit_contacts(.:format)
    def edit_contacts
      @form = 'form_contacts'
      render :edit
    end

    # GET    /orders/:id/edit_delivery(.:format)
    def edit_delivery
      @form = 'form_delivery'
      render :edit
    end

    # GET    /orders/:id/edit_payment(.:format)
    def edit_payment
      @form = 'form_payment'
      render :edit
    end

    # PATCH/PUT  /orders/:id(.:format)
    def update
      if @order.update(order_params)
        redirect_to "/magaz/orders/#{@order.id}/#{params[:member]}", notice: t('.success')
      else
        @form = params[:form]
        render :edit
      end
    end

    # DELETE /orders/:id(.:format)
    def destroy
      @order.destroy
      redirect_to orders_path, notice: t('.success')
    end

    # PATCH  /orders/:id/recount(.:format)
    def recount
      params.require(:items)
      @order.recount(params[:items])
      redirect_to edit_items_order_path(@order)
    end

    private

      def set_order
        @order = Order.find(params[:id])
      end

      def order_params
        params.require(:order).permit(:customer, :company, :phone, :email, :delivery_id, :address1, :address2, :address3, :address4, :post_code, :payment_id, :status_id, :pdt, :manager_comment, :form)
      end

  end
end