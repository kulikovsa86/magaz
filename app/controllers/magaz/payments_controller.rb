# == Schema Information
#
# Table name: magaz_payments
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  note       :text
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require_dependency "magaz/application_controller"

module Magaz
  class PaymentsController < ApplicationController

    before_action :set_payment, only: [:edit, :update, :destroy, :up, :down]

    # GET    /payments(.:format)
    def index
      @payments = Payment.order(:position)
    end

    # GET    /payments/new(.:format)
    def new
      @payment = Payment.new
    end

    # POST   /payments(.:format)
    def create
      @payment = Payment.new(payment_params)
      if @payment.save
        redirect_to edit_payment_path(@payment), notice: t('.success')
      else
        render :new
      end
    end

    # GET    /payments/:id/edit(.:format)
    def edit
    end

    # PATCH/PUT  /payments/:id(.:format)
    def update
      if @payment.update(payment_params)
        redirect_to edit_payment_path(@payment), notice: t('.success')
      else
        render :edit
      end
    end

    # PATCH  /payments/:payment_id/up(.:format)
    def up
      @payment.move_higher
      redirect_to payments_path
    end

    # PATCH  /payments/:payment_id/down(.:format)
    def down
      @payment.move_lower
      redirect_to payments_path
    end

    # DELETE /payments/:id(.:format)
    def destroy
      @payment.destroy
      redirect_to payments_path, notice: t('.success')
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_payment
        if params[:id]
          @payment = Payment.find(params[:id])
        else
          @payment = Payment.find(params[:payment_id])
        end
      end

      def payment_params
        params.require(:payment).permit(:code, :name, :note)
      end

  end
end
