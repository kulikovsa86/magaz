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
      @product = Product.find_by_permalink(params[:product_id])
      variant = @product.variants.create(variant_params)
      params[:variant][:property_values].each do |property_id, value|
        property = Property.find(property_id)
        variant.property_values.create(property: property, value: value)
      end
      redirect_to edit_product_path(@product), notice: t('.success')
    end

    # DELETE /variants/:id(.:format)
    def destroy
      @variant = Variant.find(params[:id])
      @product = @variant.product
      @variant.destroy
      redirect_to edit_product_path(@product), notice: t('.success')
    end

    private
      def variant_params
        params.require(:variant).permit(:price, property_values: [])
      end
  end
end