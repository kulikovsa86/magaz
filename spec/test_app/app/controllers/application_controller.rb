class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_cart, :has_cart?

  private

    def current_cart
      @cart = Magaz::Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      @cart = Magaz::Cart.create
      session[:cart_id] = @cart.id
      @cart
    end

    def has_cart?
      session[:cart_id]
    end



end
