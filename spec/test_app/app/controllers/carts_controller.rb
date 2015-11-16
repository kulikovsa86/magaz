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

  # DELETE /item/:id(.:format)
  def delete_item
    current_cart.delete_item(params[:id])
    if current_cart.empty?
      current_cart.destroy
      session[:cart_id] = nil
      redirect_to root_path
    else
      redirect_to cart_path
    end
  end

  # POST  /recount(.:format)
  def recount
    current_cart.recount(params.require(:items))
    redirect_to cart_path
  end
end
