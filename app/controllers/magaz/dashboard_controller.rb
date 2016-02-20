require_dependency "magaz/application_controller"

module Magaz
  class DashboardController < ApplicationController
    def index
      @new_products = Product.order(created_at: :desc).limit(10)
    end
  end
end
