require_dependency "magaz/application_controller"

module Magaz
  class ProductsController < ApplicationController
    before_action :set_product, only: [:edit, :update, :destroy]

    # GET /categories/:category_id/products(.:format)
    def index
      @parent_category = Category.find_by_permalink(params[:category_id])
      @products = @parent_category.products
    end

    # GET /categories/:category_id/products/new(.:format)
    def new
      @parent_category = Category.find_by_permalink(params[:category_id])
      @category = @parent_category
      @product = Product.new
    end

    # GET /products/1/edit
    def edit
      @parent_category = @product.category
    end

    # POST /categories/:category_id/products(.:format)
    def create
      @parent_category = Category.find_by_permalink(params[:category_id])
      @product = Product.new(product_params)
      @product.category_id = @parent_category.id
      if @product.save
        redirect_to edit_product_path(@product), notice: t('.success')
      else
        render :new
      end
    end

    # PATCH/PUT /products/1
    def update
      if @product.update(product_params)
        redirect_to edit_product_path(@product), notice: t('.success')
      else
        render :edit
      end
    end

    # DELETE /products/1
    def destroy
      @parent_category = @product.category
      @product.destroy
      redirect_to category_products_path(@parent_category), notice: t('.success')
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_product
        @product = Product.find_by_permalink(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def product_params
        params.require(:product).permit(:name, :description, :price, :hidden, :article, :weight)
      end
  end
end
