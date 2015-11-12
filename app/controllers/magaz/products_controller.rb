require_dependency "magaz/application_controller"

module Magaz
  class ProductsController < ApplicationController
    before_action :set_product, only: [:edit, :update, :up, :down, :destroy, :upload, :gallery, :image_up, :image_down, :image_destroy]
    before_action :set_image, only: [:image_up, :image_down, :image_destroy]
    before_action :set_parent_category, only: [:index, :new, :create]

    # GET /categories/:category_id/products(.:format)
    def index
      @products = @parent_category.products.order(:position)
    end

    # GET /categories/:category_id/products/new(.:format)
    def new
      @category = @parent_category
      @product = Product.new
    end

    # GET /products/1/edit
    def edit
      @parent_category = @product.category
    end

    # POST /categories/:category_id/products(.:format)
    def create
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

    # PATCH  /products/:product_id/up(.:format)
    def up
      @product.move_higher
      redirect_to category_products_path(@product.category)
    end

    # PATCH  /products/:product_id/down(.:format)
    def down
      @product.move_lower
      redirect_to category_products_path(@product.category)
    end

    # DELETE /products/1
    def destroy
      @parent_category = @product.category
      @product.destroy
      if @parent_category.products.empty?
        redirect_to categories_path(@parent_category), notice: t('.success')
      else
        @products = @parent_category.products
        render :index, notice: t('.success')
      end
    end

    # POST   /products/:product_id/upload(.:format)
    def upload
      params.permit(:picture)
      @product.images << Image.create(picture: params[:picture])
      redirect_to product_gallery_path(@product), notice: t('.success')
    end

    # GET    /products/:product_id/gallery(.:format)
    def gallery
      @parent_category = @product.category
      @ordered_images = @product.images.order(:position)
    end

    # PATCH  /products(/:product_id)/images(/:image_id)/up(.:format)
    def image_up
      @image.move_higher
      redirect_to product_gallery_path(@product)
    end

    # PATCH  /products(/:product_id)/images(/:image_id)/down(.:format)
    def image_down
      @image.move_lower
      redirect_to product_gallery_path(@product)
    end

    # DELETE /products(/:product_id)/images(/:image_id)(.:format)
    def image_destroy
      @image.destroy
      redirect_to product_gallery_path(@product)
    end

    private

      def set_parent_category
        @parent_category = Category.find_by_permalink(params[:category_id])
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_product
        if params[:id]
          @product = Product.find_by_permalink(params[:id])
        elsif params[:product_id]
          @product = Product.find_by_permalink(params[:product_id])
        else
          @product = Product.new
        end
      end

      def set_image
        @image = Image.find(params[:image_id])
      end

      # Only allow a trusted parameter "white list" through.
      def product_params
        params.require(:product).permit(:name, :description, :price, :hidden, :article, :weight)
      end
  end
end