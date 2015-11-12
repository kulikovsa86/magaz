class CartsController < ApplicationController
  def index
    @cart = current_cart
    @items = @cart.items
  end

  def destroy
    current_cart.destroy
    session[:cart_id] = nil
    redirect_to root_path
  end
end
