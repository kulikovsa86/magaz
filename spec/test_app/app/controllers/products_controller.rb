class ProductsController < ApplicationController
  def index
    @products = Magaz::Product.all
  end

  def show
    @product = Magaz::Product.find_by_permalink(params[:id])
  end

  def add2cart
    params.permit(:product_id, :variant_id, :count)
    current_cart.add_item(params)
    redirect_to cart_path
  end

  def send_mail
    OrderNotifier.tested.deliver_now
    redirect_to root_path
  end
end
