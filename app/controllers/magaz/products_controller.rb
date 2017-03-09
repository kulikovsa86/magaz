# == Schema Information
#
# Table name: magaz_products
#
#  id           :integer          not null, primary key
#  name         :string
#  var_name     :string
#  category_id  :integer
#  description  :text
#  price        :decimal(8, 2)
#  hidden       :boolean          default(TRUE)
#  article      :string
#  weight       :decimal(6, 3)
#  position     :integer
#  permalink    :string
#  input_dim_id :integer
#  calc_dim_id  :integer
#  correct      :boolean          default(FALSE)
#  moulded      :boolean          default(FALSE)
#  stock        :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  short_name   :string
#

require_dependency "magaz/application_controller"

module Magaz
  class ProductsController < ApplicationController
    before_action :set_product, only: [:edit, :update, :up, :down, :destroy, :upload, :gallery, :properties, :properties_create, :image_up, :image_down, :image_destroy, :descr, :seo, :next, :prev]
    before_action :set_image, only: [:image_up, :image_down, :image_destroy]
    before_action :set_parent_category, only: [:index, :new, :create]
    before_action :set_dimensions, only: [:new, :edit, :create, :update]

    # GET /categories/:category_id/products(.:format)
    def index
      @products = @parent_category.products.order(:position).paginate(page: params[:page], per_page: 10)
    end

    # GET /categories/:category_id/products/new(.:format)
    def new
      @category = @parent_category
      @product = Product.new
    end

    # GET /products/1/edit
    def edit
    end

    # GET    /products(/:product_id)/descr(.:format)
    def descr
    end

    # GET    /products(/:product_id)/seo(.:format)
    def seo
    end

    # POST /categories/:category_id/products(.:format)
    def create
      @product = Product.new(product_params)
      @product.category_id = @parent_category.id
      @category = @parent_category
      if @product.save
        redirect_to edit_product_path(@product), notice: t('.success')
      else
        render :new        
      end
    end

    # PATCH/PUT /products/1
    def update
      if @product.update(product_params)
        if params[:descr]
          redirect_to product_description_path(@product), notice: t('.success')
        elsif params[:seo]
          redirect_to product_seo_path(@product), notice: t('.success')
        else
          redirect_to edit_product_path(@product), notice: t('.success')
        end
      else
        @parent_category = @product.category
        render :edit
      end
    end

    # PATCH  /products/:product_id/up(.:format)
    def up
      @product.move_higher
      redirect_to category_products_path(@parent_category)
    end

    # PATCH  /products/:product_id/down(.:format)
    def down
      @product.move_lower
      redirect_to category_products_path(@parent_category)
    end

    # DELETE /products/1
    def destroy
      if @demo_mode
        redirect_to edit_product_path(@product), alert: t("magaz.demo.disabled")
      else
        @product.destroy
        if @parent_category.products.empty?
          redirect_to categories_path(@parent_category), notice: t('.success')
        else
          redirect_to category_products_path(@parent_category), notice: t('.success')
        end
      end
    end

    # POST   /products/:product_id/upload(.:format)
    def upload
      if @demo_mode
        redirect_to edit_product_path(@product), alert: t("magaz.demo.disabled")
      else
        if params[:picture]
          @product.images << Image.create(picture: params[:picture])
        end
        redirect_to product_gallery_path(@product), notice: t('.success')
      end
    end

    # GET    /products/:product_id/gallery(.:format)
    def gallery
      @parent_category = @product.category
      @ordered_images = @product.images.order(:position)
    end

    # GET    /products/:product_id/properties(.:format)
    def properties
      @parent_category = @product.category
      @property_groups = @product.category.property_groups
    end

    # POST  /products/:product_id/properties_create(.:format)
    def properties_create
      @product.update(var_name: params[:var_name])
      @product.set_properties(params.require(:properties))
      redirect_to product_properties_path(@product), notice: t('.success')
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
      if @demo_mode
        redirect_to edit_product_path(@product), alert: t("magaz.demo.disabled")
      else
        @image.destroy
        redirect_to product_gallery_path(@product)
      end
    end

    # PATCH  /products/shift(.:format)
    def shift
      shift_params = params.require(:shift).permit(:parent, :target, :items => [:id, :checked] )
      @parent_category = Category.find_by_permalink(shift_params[:parent])
      Product.shift(shift_params, params.include?(:remove))
      redirect_to category_products_path(@parent_category), notice: 'Операция выполнена'
    end

    # GET    /products/:product_id/next(.:format)
    def next
      item = @product.lower_item
      @product = item if item
      redirect_to_product
    end

    # GET    /products/:product_id/prev(.:format)
    def prev
      item = @product.higher_item
      @product = item if item
      redirect_to_product
    end

    private

      def redirect_to_product
        if params[:to] == 'descr'
          redirect_to product_description_path(@product)
        elsif params[:to] == 'gallery'
          redirect_to product_gallery_path(@product)
        elsif params[:to] == 'prop'
          redirect_to product_properties_path(@product)
        elsif params[:to] == 'vars'
          redirect_to product_variants_path(@product)
        elsif params[:to] == 'comments'
          redirect_to product_comments_path(@product)
        else
          redirect_to edit_product_path(@product)
        end
      end

      def set_parent_category
        @parent_category = Category.find_by_permalink(params[:category_id])
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_product
        if params[:id]
          @product = Product.find_by_permalink(params[:id])
          @parent_category = @product.category
        elsif params[:product_id]
          @product = Product.find_by_permalink(params[:product_id])
          @parent_category = @product.category
        else
          @product = Product.new
        end
      end

      def set_image
        @image = Image.find(params[:image_id])
      end

      # Only allow a trusted parameter "white list" through.
      def product_params
        params.require(:product).permit(:name, :short_name, :description, :price, :hidden, :article, :weight, :input_dim_id, :calc_dim_id, :correct, :moulded, :title, :meta_description, :meta_keywords)
      end

      def product_properties
        params.require(:properties)
      end

      def set_dimensions
        @dimensions = Dimension.all
      end
  end
end
