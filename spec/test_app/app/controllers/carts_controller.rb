class CartsController < ApplicationController

  def index
    unless has_cart?
      redirect_to root_path
    else
      @cart = current_cart
      @items = @cart.items
    end
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

  # POST   /recount(.:format)
  def recount
    current_cart.recount(params.require(:items))
    redirect_to cart_path
  end

  # GET    /order(.:format)
  def new_order
    unless has_cart?
      redirect_to root_path
    else
      @cart = current_cart
      @order = Magaz::Order.new
    end
  end

  # POST   /order(.:format)
  def create_order
    @order = Magaz::Order.new(params.require(:order).permit(:customer, :company, :email, :phone, :delivery, :address1, :address2, :address3, :address4, :post_code, :payment, :pdt, :customer_comment))
    @order.skip_delivery_valid = true
    @order.skip_payment_valid = true
    @order.take_items_from_cart(current_cart)
    if @order.save
      destroy_cart
      redirect_to root_path, notice: 'Новый заказ создан'
    else
      @cart = current_cart
      render :new_order
    end
  end

end
