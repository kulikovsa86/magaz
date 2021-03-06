# == Schema Information
#
# Table name: magaz_orders
#
#  id               :integer          not null, primary key
#  customer         :string
#  company          :string
#  phone            :string
#  email            :string
#  delivery_id      :integer
#  address1         :string
#  address2         :string
#  address3         :string
#  address4         :string
#  post_code        :string
#  payment_id       :integer
#  status_id        :integer
#  pdt              :datetime
#  customer_comment :text
#  manager_comment  :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  offer            :boolean
#  offer_sent       :datetime
#  payer            :text
#  consignee        :text
#

require_dependency "magaz/application_controller"

module Magaz
  class OrdersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :invalid_request
    include PdfUtils

    before_action :check_profile, only: [:update, :recount]
    before_action :set_order, only: [:edit, :update, :destroy, :edit_items, :edit_contacts, 
      :edit_delivery, :edit_payment, :edit_status, :recount, :bill, :send_bill, :send_offer]

    # GET    /orders(.:format)
    def index
      @filter = 'all'
      @filter = params[:filter] if params[:filter]
      if @filter == 'opened'
        @orders = Order.opened
      elsif @filter == 'closed'
        @orders = Order.closed
      elsif @filter == 'new'
        @orders = Order.fresh
      else
        @orders = Order.order(created_at: :desc)
      end
      @orders = @orders.paginate(page: params[:page], per_page: 10)
    end

    # GET    /orders/new(.:format)
    def new
      @order = Order.new
    end

    # POST   /orders(.:format)
    def create
      @order = Order.new(order_params)
      @order.offer = true
      if @order.save
        redirect_to edit_contacts_order_path(@order), notice: t('.success')
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
      @moulded_flag = @order.has_moulded?
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

    # GET    /orders/:id/edit_status(.:format)
    def edit_status
      @form = 'form_status'
      @history = @order.history
      render :edit
    end

    # PATCH/PUT  /orders/:id(.:format)
    def update
      status_id = @order.status_id
      if @order.update(order_params)
        if status_id != @order.status_id
          notify( event_type: 'status updated', order: @order.id, user: current_user.id )
        end
        redirect_to "/magaz/orders/#{@order.id}/#{params[:member]}", notice: t('.success')
      else
        @form = params[:form]
        render :edit
      end
    end

    # DELETE /orders/:id(.:format)
    def destroy
      redirect_to :back, alert: "Операция запрещена. Используйте статус 'Отменен'"
      # @order.destroy
      # redirect_to orders_path(filter: 'opened'), notice: t('.success')
    end

    # PATCH  /orders/:id/recount(.:format)
    def recount
      params.require(:items)
      unless params[:recount_unit]
        if @order.recount(params[:items])
          notify( event_type: 'count changed', order: @order.id, user: current_user.id )
        end
      else
        if @order.recount_unit(params[:items])
          notify( event_type: 'unit count changed', order: @order.id, user: current_user.id )
        end
      end
      redirect_to edit_items_order_path(@order), notice: t('.success')
    end

    # GET    /order/:id/bill(.:format)
    def bill
      filename, filepath = create_bill(@order)
      send_data File.read(filepath), filename: filename, type: "application/pdf"
    end

    # GET    /order/:id/send_bill(.:format)
    def send_bill
      notify( event_type: 'send bill', order: @order.id, user: current_user.id )
      redirect_to edit_payment_order_path(@order), notice: t('.success')
    end

    # GET    /order/:id/send_offer(.:format)
    def send_offer
      unless @order.offer
        redirect_to edit_items_order_path(@order), alert: "Только для заказов КП"
      else
        @order.update(offer_sent: Time.now)
        notify( event_type: 'send offer', order: @order.id, user: current_user.id )
        redirect_to edit_items_order_path(@order), notice: t('.success')
      end
    end

    private

      def set_order
        @order = Order.find(params[:id])
      end

      def order_params
        params.require(:order).permit(:customer, :company, :phone, :email, :delivery_id, :address1, :address2, :address3, :address4, :post_code, :payment_id, :status_id, :pdt, :manager_comment, :form, :payer, :consignee)
      end

      def check_profile
        unless current_user.profile
          redirect_to :back, alert: "Операция запрещена: не заполнен профиль пользователя"
        end
      end

      def invalid_request
        redirect_to orders_path, alert: "Указанный заказ не найден"
      end
  end
end
