require_dependency "magaz/application_controller"

module Magaz
  class VariantsController < ApplicationController

    before_action :set_product, only: [:index, :new, :create, :shift]
    before_action :set_variant, only: [:edit, :update, :up, :down]

    # GET    /products/:product_id/variants(.:format)
    def index
      @parent_category = @product.category
      @variants = @product.variants.order(:position)
    end

    # GET    /products/:product_id/variants/new(.:format)
    def new
      @p = @product
      @parent_category = @product.category
      @variant = Variant.new
      @property_groups = @product.category.property_groups
      @images = @product.images
      @options = []
      @product.images.each { |image| @options << [image.id, image.id, {:'data-img-src' => image.picture.url}] }
    end

    # POST   /products/:product_id/variants(.:format)
    def create
      @variant = Variant.new(variant_params)
      @variant.name = params[:var_name]
      @variant.product_id = @product.id
      if @variant.save
        @variant.set_properties(params[:properties]) if params[:properties]
        redirect_to product_variants_path(@product), notice: t('.success')
      else
        @parent_category = @product.category
        @property_groups = @product.category.property_groups
        @images = @product.images
        @options = []
        @product.images.each { |image| @options << [image.id, image.id, {:'data-img-src' => image.picture.url}] }
        render :new
      end
    end

    # GET    /variants/:id/edit(.:format)
    def edit
      @product = @variant.product
      @parent_category = @product.category
      @property_groups = @product.category.property_groups
      @images = @product.images
      @options = []
      @product.images.each { |image| @options << [image.id, image.id, {:'data-img-src' => image.picture.url}] }
    end

    # PATCH/PUT  /variants/:id(.:format)
    def update
      @variant.attributes = variant_params
      @variant.name = params[:var_name]
      if @variant.save
        @variant.set_properties(params[:properties]) if params[:properties]
        redirect_to product_variants_path(@variant.product), notice: t('.success')
      else
        @product = @variant.product
        @parent_category = @product.category
        @property_groups = @product.category.property_groups
        @images = @product.images
        @options = []
        @product.images.each { |image| @options << [image.id, image.id, {:'data-img-src' => image.picture.url}] }
        render :edit
      end
    end

    # POST   /variants/shift(.:format)
    def shift
      shift_params = params.require(:shift).permit(:product, :target, :items => [:id, :checked] )
      @product = Product.find_by_permalink(shift_params[:product])
      Variant.shift(shift_params, true)
      redirect_to product_variants_path(@product), notice: t('.success')
    end

    # PATCH  /variants/:variant_id/up(.:format)
    def up
      @variant.move_higher
      redirect_to product_variants_path(@variant.product)
    end

    # PATCH  /variants/:variant_id/down(.:format)
    def down
      @variant.move_lower
      redirect_to product_variants_path(@variant.product)
    end

    # DELETE /variants/:id(.:format)
    def destroy
      @variant = Variant.find(params[:id])
      @product = @variant.product
      @variant.destroy
      redirect_to product_variants_path(@product), notice: t('.success')
    end

    private
      def set_product
        @product = Product.find_by_permalink(params[:product_id])
      end

      def set_variant
        if params[:id]
          @variant = Variant.find(params[:id])
        elsif params[:variant_id]
          @variant = Variant.find(params[:variant_id])
        else
          @variant = Variant.new
        end
      end

      def variant_params
        params.require(:variant).permit(:price, :name, :hidden, image_ids: [])
      end

      def variant_properties
        params.require(:properties)
      end
  end
end