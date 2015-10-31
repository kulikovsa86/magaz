require_dependency "magaz/application_controller"

module Magaz
  class VariantsController < ApplicationController

    # GET    /products/:product_id/variants/new(.:format)
    def new
      @product = Product.find_by_permalink(params[:product_id])
      @parent_category = @product.category
      @variant = Variant.new
      @properties = @product.category.properties
    end

    # POST   /products/:product_id/variants(.:format)
    def create
      redirect_to edit_product_path(Product.find_by_permalink(params[:product_id]))
    end
  end
end