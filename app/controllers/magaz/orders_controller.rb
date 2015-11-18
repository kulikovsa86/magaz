require_dependency "magaz/application_controller"

module Magaz
  class OrdersController < ApplicationController

    # GET    /orders(.:format)
    def index
      @orders = Order.order(created_at: :desc)
    end

  end
end